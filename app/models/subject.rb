class Subject < ApplicationRecord
  belongs_to :teacher
  has_many :sections, dependent: :destroy, inverse_of: :subject

  after_create :update_teacher_salary
  after_update :update_after_change
  before_destroy :store_teacher
  after_destroy :update_stored_teacher_salary

  private

  def update_after_change
    if saved_change_to_number_of_units?
      teacher&.update_monthly_salary
    end

    if saved_change_to_number_of_units? || saved_change_to_per_unit_rate?
      update_enrolled_students
    end
  end

  def update_enrolled_students
    sections.includes(classlists: :student).each do |section|
      section.classlists.each do |classlist|
        update_student_totals(classlist.student)
      end
    end
  end

  def update_student_totals(student)
    subject_count = student.classlists.count

    number_of_units = student.classlists.sum do |classlist|
      classlist.section.subject.number_of_units
    end

    tuition_fee = student.classlists.sum do |classlist|
      subject = classlist.section.subject
      subject.number_of_units * subject.per_unit_rate
    end

    student.update_columns(
      subject_count: subject_count,
      number_of_units: number_of_units,
      tuition_fee: tuition_fee
    )
  end

  def update_teacher_salary
    teacher&.update_monthly_salary
  end

  def store_teacher
    @subject_teacher = teacher
  end

  def update_stored_teacher_salary
    @subject_teacher&.update_monthly_salary
  end
end
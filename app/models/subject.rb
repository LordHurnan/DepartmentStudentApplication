class Subject < ApplicationRecord

  belongs_to :teacher

  has_many :sections, dependent: :destroy, inverse_of: :subject

  after_create :update_teacher_salary

  before_destroy :store_teacher
  after_destroy :update_stored_teacher_salary

  private

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
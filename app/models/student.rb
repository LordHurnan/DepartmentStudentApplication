class Student < ApplicationRecord
  belongs_to :department, counter_cache: :students_count
  has_many :classlists, dependent: :destroy
  has_many :sections, through: :classlists, dependent: :destroy

  after_create :increment_department_count
  after_destroy :decrement_department_count
  after_update :department_was_changed

  def display_name
    [ department&.name, name ].compact_blank.join(" - ")
  end

  private

  def increment_department_count
    department&.increment!(:students_count)
  end

  def decrement_department_count
    department&.decrement!(:students_count)
  end

  def department_was_changed
    return unless saved_change_to_department_id?

    old_department = Department.find_by(id: department_id_before_last_save)
    old_department&.decrement!(:students_count)
    department&.increment!(:students_count)
  end
end
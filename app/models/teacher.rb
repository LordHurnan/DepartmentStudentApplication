class Teacher < ApplicationRecord
  belongs_to :department, counter_cache: :teachers_count
  has_many :subjects, dependent: :destroy

  after_create :increment_department_count
  after_destroy :decrement_department_count
  after_update :department_was_changed
  after_update :update_salary_if_rate_changed

  def display_name
    [department&.name, name].compact_blank.join(" - ")
  end

  def update_monthly_salary
    self.monthly_salary = subjects.count * per_unit_rate.to_d
    save!
  end

  private

  def increment_department_count
    department&.increment!(:teachers_count)
  end

  def decrement_department_count
    department&.decrement!(:teachers_count)
  end

  def department_was_changed
    return unless saved_change_to_department_id?

    old_department = Department.find_by(id: department_id_before_last_save)
    old_department&.decrement!(:teachers_count)
    department&.increment!(:teachers_count)
  end

  def update_salary_if_rate_changed
    return unless saved_change_to_per_unit_rate?

    update_monthly_salary
  end
end
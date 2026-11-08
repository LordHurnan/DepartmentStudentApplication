class Laboratory < ApplicationRecord
  belongs_to :department, counter_cache: :laboratory

  after_create :increment_department_count
  after_destroy :decrement_department_count
  after_update :department_was_changed

  def self.ransackable_attributes(auth_object = nil)
    %w[id name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[department]
  end

  private

  def increment_department_count
    department&.increment!(:laboratory)
  end

  def decrement_department_count
    department&.decrement!(:laboratory)
  end

  def department_was_changed
    return unless saved_change_to_department_id?

    old_department = Department.find_by(id: department_id_before_last_save)
    old_department&.decrement!(:laboratory)
    department&.increment!(:laboratory)
  end


end

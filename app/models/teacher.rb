require "friendly_id"

class Teacher < ApplicationRecord
  extend FriendlyId

  has_paper_trail

  friendly_id :name, use: :slugged

  belongs_to :department, counter_cache: :teachers_count
  has_many :subjects, dependent: :destroy

  after_update :update_salary_if_rate_changed

  def self.ransackable_attributes(auth_object = nil)
    %w[name department_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[department subjects]
  end

  def display_name
    [ department&.name, name ].compact_blank.join(" - ")
  end

  def update_monthly_salary
    total_units = subjects.sum(:number_of_units)
    self.monthly_salary = total_units * per_unit_rate.to_d
    save!
  end

  private

  def update_salary_if_rate_changed
    return unless saved_change_to_per_unit_rate?

    update_monthly_salary
  end
end
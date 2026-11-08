require "friendly_id"

class Student < ApplicationRecord
  extend FriendlyId

  has_paper_trail

  friendly_id :name, use: :slugged

  belongs_to :department, counter_cache: :students_count
  has_many :classlists, dependent: :destroy
  has_many :sections, through: :classlists, dependent: :destroy

  # Ransack: allowlist what can be searched/filtered
  def self.ransackable_attributes(auth_object = nil)
    %w[name year_level program department_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[department sections]
  end

  def display_name
    [ department&.name, name ].compact_blank.join(" - ")
  end
end
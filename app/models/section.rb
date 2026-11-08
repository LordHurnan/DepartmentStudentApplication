class Section < ApplicationRecord
  belongs_to :subject, counter_cache: :section_count
  has_many :classlists, dependent: :destroy
  has_many :students, through: :classlists, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[id name room timeslot subject_id student_count]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[subject students]
  end

  def display_name
    [ subject&.name, name ].compact_blank.join("-")
  end
end
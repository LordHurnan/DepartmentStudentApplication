class Classlist < ApplicationRecord
  belongs_to :student
  belongs_to :section, counter_cache: :student_count
end

class Department < ApplicationRecord
  has_many :students, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :laboratories, dependent: :destroy

  def display_info
    "#{name} (#{students_count} students, #{teachers_count} teachers, #{laboratory} labs)"
  end
end
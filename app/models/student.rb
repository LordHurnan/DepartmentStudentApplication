class Student < ApplicationRecord
  belongs_to :department
  has_many :classlists, dependent: :destroy
end
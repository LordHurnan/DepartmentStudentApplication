class Section < ApplicationRecord
  has_many :classlists, dependent: :destroy
end
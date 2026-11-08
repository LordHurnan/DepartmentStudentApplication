class Laboratory < ApplicationRecord
  belongs_to :department, counter_cache: :laboratory

  def self.ransackable_attributes(auth_object = nil)
    %w[id name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[department]
  end
end
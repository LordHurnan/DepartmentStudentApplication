class AddPerUnitRateToSubjects < ActiveRecord::Migration[8.1]
  def change
    add_column :subjects, :per_unit_rate, :double, default: 0.0
  end
end
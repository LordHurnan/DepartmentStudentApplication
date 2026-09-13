class AddSalaryFieldsToTeachers < ActiveRecord::Migration[8.1]
  def change
    add_column :teachers, :monthly_salary, :decimal
    add_column :teachers, :per_unit_rate, :decimal
  end
end

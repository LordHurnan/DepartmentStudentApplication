class AddDepartmentColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :departments, :students_count, :integer, default: 0
    add_column :departments, :teachers_count, :integer,default: 0
    add_column :departments, :laboratory, :integer, default: 0
  end
end

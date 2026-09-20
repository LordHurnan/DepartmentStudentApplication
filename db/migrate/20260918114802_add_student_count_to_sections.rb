class AddStudentCountToSections < ActiveRecord::Migration[8.1]
  def change
    add_column :sections, :student_count, :integer, default: 0 unless column_exists?(:sections, :student_count)
  end
end
class BackfillDepartmentCounters < ActiveRecord::Migration[8.1]
  def up
    Department.find_each do |department|
      Department.reset_counters(department.id, :students)
      Department.reset_counters(department.id, :teachers)
      Department.reset_counters(department.id, :laboratories)
    end
  end

  def down
  end
end

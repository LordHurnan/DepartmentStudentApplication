class BackfillSubjectSectionCounts < ActiveRecord::Migration[8.1]
  def up
    Subject.find_each do |subject|
      Subject.reset_counters(subject.id, :sections)
    end
  end

  def down
  end
end
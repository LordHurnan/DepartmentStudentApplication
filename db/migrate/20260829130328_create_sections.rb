class CreateSections < ActiveRecord::Migration[8.1]
  def change
    create_table :sections do |t|
      t.string :name
      t.string :room
      t.string :timeslot

      t.timestamps
    end
  end
end

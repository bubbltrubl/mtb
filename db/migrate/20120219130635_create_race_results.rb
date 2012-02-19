class CreateRaceResults < ActiveRecord::Migration
  def change
    create_table :race_results do |t|
      t.integer :race_id, :null => false
      t.integer :rider_id, :null => false
      t.integer :position, :null => false
      t.integer :points, :null => false

      t.timestamps
    end
  end
end

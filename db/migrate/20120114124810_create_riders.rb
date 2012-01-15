class CreateRiders < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      t.string :name
      t.integer :value
      t.integer :points
      t.boolean :active, :default => true
      t.integer :cycling_team_id, :null => false

      t.timestamps
    end
  end
end

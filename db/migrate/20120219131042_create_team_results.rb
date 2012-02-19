class CreateTeamResults < ActiveRecord::Migration
  def change
    create_table :team_results do |t|
      t.integer :race_id, :null => false
      t.integer :team_id, :null => false
      t.integer :points, :null => false

      t.timestamps
    end
  end
end

class CreateRaceTeams < ActiveRecord::Migration
  def change
    create_table :race_teams do |t|
      t.integer :race_id, :null => false
      t.integer :team_id, :null => false

      t.timestamps
    end
  end
end

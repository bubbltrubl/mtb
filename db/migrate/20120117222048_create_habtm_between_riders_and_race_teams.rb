class CreateHabtmBetweenRidersAndRaceTeams < ActiveRecord::Migration
  def change
    create_table :race_teams_riders, :id => false do |t|
      t.integer :race_team_id, :null => false
      t.integer :rider_id, :null => false
    end
  end
end

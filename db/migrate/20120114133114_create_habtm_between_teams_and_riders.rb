class CreateHabtmBetweenTeamsAndRiders < ActiveRecord::Migration
  def change
    create_table :riders_teams, :id => false do |t|
      t.integer :team_id, :null => false
      t.integer :rider_id, :null => false
    end
  end
end

class CreateCyclingTeams < ActiveRecord::Migration
  def change
    create_table :cycling_teams do |t|
      t.string :name
      t.string :short_name
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end

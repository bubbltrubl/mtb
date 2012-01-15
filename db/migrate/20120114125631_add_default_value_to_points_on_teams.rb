class AddDefaultValueToPointsOnTeams < ActiveRecord::Migration
  def up
    change_column(:teams, :points, :integer, :default => 0)
  end

  def down
    change_column(:teams, :points, :integer, :default => nil)
  end
end

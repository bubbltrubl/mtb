class AddDefaultValueToPointsOnRiders < ActiveRecord::Migration
  def up
    change_column(:riders, :points, :integer, :default => 0) 
  end

  def down
    change_column(:riders, :points, :integer, :default => nil)
  end
end

class AddDefaultValueToPaidOnTeams < ActiveRecord::Migration
  def up 
    change_column(:teams, :paid, :boolean, :default => false)
  end

  def down
    change_column(:teams, :paid, :boolean, :default => nil)
  end
end

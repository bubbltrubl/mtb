class AddPeriodToRace < ActiveRecord::Migration
  def up
    add_column :races, :period_id, :integer
  end

  def down
    remove_column :races, :period_id
  end
end

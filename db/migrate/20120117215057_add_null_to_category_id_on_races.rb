class AddNullToCategoryIdOnRaces < ActiveRecord::Migration
  def up
    change_column(:races, :category_id, :integer, :null => false)
  end

  def down
    change_column(:races, :category_id, :integer, :null => true)
  end
end

class ChangePointsFromCategoriesToString < ActiveRecord::Migration
  def up
    change_column :categories, :points, :string
  end

  def down
    change_column :categroies, :points, :integer
  end
end

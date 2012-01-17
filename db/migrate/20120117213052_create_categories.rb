class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :nr_of_riders
      t.integer :points

      t.timestamps
    end
  end
end

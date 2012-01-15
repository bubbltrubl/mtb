class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :points
      t.boolean :paid
      t.integer :user_id, :null => false

      t.timestamps
    end
  end
end

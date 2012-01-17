class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.datetime :date
      t.datetime :end_date
      t.boolean :is_tour
      t.string :previous_winner
      t.integer :race_id
      t.integer :category_id
      t.boolean :results_ready, :default => false
      t.boolean :team_time_trial, :default => false

      t.timestamps
    end
  end
end

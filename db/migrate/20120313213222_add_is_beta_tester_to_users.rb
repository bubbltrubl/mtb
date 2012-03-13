class AddIsBetaTesterToUsers < ActiveRecord::Migration
  def up
    add_column :users, :is_beta_tester, :boolean, :default => false
  end
  
  def down
    remove_column :users, :is_beta_tester
  end
end

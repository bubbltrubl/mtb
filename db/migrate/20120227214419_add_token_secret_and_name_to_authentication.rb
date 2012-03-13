class AddTokenSecretAndNameToAuthentication < ActiveRecord::Migration
  def up
    add_column :authentications, :token, :string
    add_column :authentications, :secret, :string
    add_column :authentications, :name, :string
  end

  def down
    remove_column :authentications, :token
    remove_column :authentications, :secret
    remove_column :authentications, :name
  end
end

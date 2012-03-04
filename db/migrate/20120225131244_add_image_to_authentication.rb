class AddImageToAuthentication < ActiveRecord::Migration
  def up
    add_column :authentications, :image_url, :string
  end
  
  def down
    remove_column :authentications, :image_url
  end
end

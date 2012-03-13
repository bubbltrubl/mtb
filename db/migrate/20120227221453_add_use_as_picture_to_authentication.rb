class AddUseAsPictureToAuthentication < ActiveRecord::Migration
  def up 
    add_column :authentications, :use_as_picture, :boolean, :default => false
  end

  def down
    remove_column :authentications, :use_as_picture
  end
end

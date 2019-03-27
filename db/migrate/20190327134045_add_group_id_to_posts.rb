class AddGroupIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :group_id, :string
    add_column :posts, :content, :string
    remove_column :posts, :photo
    add_column :posts, :photos, :text
    add_column :posts, :app_id, :string
  end
end

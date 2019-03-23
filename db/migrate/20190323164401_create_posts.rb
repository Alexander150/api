class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :href
      t.string :file
      t.string :photo
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end

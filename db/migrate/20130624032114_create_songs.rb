class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist
      t.string :url
      t.string :categories
      t.string :album
      t.string :album_image
      t.integer :length
      t.boolean :isActive

      t.timestamps
    end
  end
end

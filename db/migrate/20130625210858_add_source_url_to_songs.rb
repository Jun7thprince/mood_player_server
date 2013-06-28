class AddSourceUrlToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :source_url, :string
  end
end

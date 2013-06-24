class Song < ActiveRecord::Base
  attr_accessible :album, :album_image, :artist, :categories, :isActive, :length, :name, :url
  validates_presence_of :name, :artist, :url, :isActive
  validates_numericality_of :length, :greater_than => 0
end

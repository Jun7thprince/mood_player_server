require 'net/http'
class Song < ActiveRecord::Base
  attr_accessible :album, :album_image, :artist, :categories, :isActive, :length, :name, :url, :source_url
  before_save :update_info, :if => :source_url_changed?

  CATEGORIES = {
    "Love" => 1,
    "Sad" => 2,
    "Relax" => 3,
    "Angry" => 4,
    "Happy" => 5,
    "No idea" => 6,
  }

  def update_info
    zing_title, zing_artist, zing_album = Song.fetch_info_from_zing(self.source_url)

    self.name = zing_title if self.name.blank?
    self.artist = zing_artist if self.artist.blank?
    self.album = zing_album if self.album.blank?
  end

  def self.get_zing_direct_link_url(url)
    uri = URI::parse(url)
    zing_page = Net::HTTP.get(uri)
    regex = /flashvars.*xmlURL=(.*)&amp;/
    xml_uri = URI::parse(regex.match(zing_page)[1])
    xml_page = Net::HTTP.get(xml_uri)
    /<source>.*CDATA\[(.*)\]\]><\/source>/m.match(xml_page)[1]
  end

  def self.fetch_info_from_zing(url)
    zing_uri = URI::parse(url)
    zing_page = Nokogiri::HTML(Net::HTTP.get(zing_uri))
    title = zing_page.css('.detail-content-title h1').first
    title &&= title.content
    author = zing_page.css('.detail-content-title h2 a').first
    author &&= author.content
    album = zing_page.css('.song-info a[href*=album]').first
    album &&= album.content

    [title, author, album]
  end
end

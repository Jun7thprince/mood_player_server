require 'uri'
require 'net/http'
require 'pry'

class SongsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :get_info
  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.json
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
    @song.categories = @song.categories.split(',')
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(params[:song])

    params[:song][:categories] = params[:song][:categories].reject { |c| c.blank? }.join(',')
    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render json: @song, status: :created, location: @song }
      else
        format.html { render action: "new" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.json
  def update
    @song = Song.find(params[:id])

    params[:song][:categories] = params[:song][:categories].reject { |c| c.blank? }.join(',')
    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  def from_category
    cat_id = params[:id].to_i
    @songs = Song.where("categories LIKE ?", "%#{cat_id}%").order("random()")

    render json: @songs.to_json(:only => [:album, :album_image, :name, :artist, :id, :url])
  end

  def get_info
    @zing_uri = URI::parse(params[:url])
    zing_page = Nokogiri::HTML(Net::HTTP.get(@zing_uri))
    title = zing_page.css('.detail-content-title h1').first
    title &&= title.content
    author = zing_page.css('.detail-content-title h2 a').first
    author &&= author.content
    album = zing_page.css('.song-info a[href*=album]').first
    album &&= album.content

    render json: { title: title, author: author, album: album }
  end
end

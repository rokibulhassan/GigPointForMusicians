class ArtistsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update]

  def index
    @artists = Artist.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @artist = current_user.build_artist || current_user.artist
    @profile = @artist.build_profile || @artist.profile
    respond_to do |format|
      format.html
    end
  end

  def edit
    @artist = Artist.find(params[:id])
    @profile = @artist.profile || @artist.build_profile
  end

  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url }
    end
  end
end

class ProfilesController < ApplicationController

  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.profile

    respond_to do |format|
      format.html
    end
  end

  def new
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.profile || @artist.build_profile

    @manage_page_url = facebook_access_permission("manage_pages,publish_stream")
    @user_groups_url = facebook_access_permission("user_groups")

    respond_to do |format|
      format.html
    end
  end

  def edit
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.profile

    @manage_page_url = facebook_access_permission("manage_pages,publish_stream")
    @user_groups_url = facebook_access_permission("user_groups")
  end


  def create
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.build_profile(params[:profile])
    @profile.artist_id = @artist.id
    respond_to do |format|
      if @profile.save
        format.html { redirect_to artist_profile_path(@artist, @profile), notice: 'Profile was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @profile = Profile.find(params[:id])
    begin
      @profile.update_attributes!(params[:profile])
      flash[:notice] = "Profile updates successfully"
      redirect_to current_user, notice: 'Profile was successfully updated.'
    rescue => ex
      flash[:error] = ex.message
      render :edit
    end
  end


  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
    end
  end
end

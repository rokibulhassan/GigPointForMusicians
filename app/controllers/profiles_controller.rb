class ProfilesController < ApplicationController
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.profile

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.profile || @artist.build_profile

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.profile
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @artist = Artist.find(params[:artist_id])
    @profile = @artist.build_profile(params[:profile])
    @profile.artist_id = @artist.id
    respond_to do |format|
      if @profile.save
        format.html { redirect_to artist_profile_path(@artist, @profile), notice: 'Profile was successfully created.' }
        format.json { render json: artist_profile_path(@artist, @profile), status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])
    begin
      @profile.update_attributes!(params[:profile])
      flash[:notice] = "Profile updates successfully"
      redirect_to edit_artist_profile_path(current_user.artist.id, current_user.artist.profile.id), notice: 'Profile was successfully updated.'
    rescue => e
      flash[:error] = e.message
      render :edit
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end
end

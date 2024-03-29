class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  def profile
    @user = user
  end

  def destroy_authentication
    @authentication = current_user.authentications.find_by_provider(params[:provider])
    @authentication.destroy
    flash[:notice] = "Successfully disconnect from #{params[:provider]} authentication."
    redirect_to edit_artist_profile_path(current_user)
  end

  def callback
    access_token = session[:fb_oauth].get_access_token(params[:code]) if params[:code]

    authentication = current_user.authentications.find_by_provider("facebook") rescue []
    authentication.update_attributes!(:credentials => access_token) if authentication.present?

    redirect_to edit_artist_profile_path(current_user.artist.id, current_user.artist.profile.id)
  end

  private

  def user
    @user = User.find params[:id] if params[:id]
  end

end

class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path
  helper_method :user_coordinates_from_ip

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if resource.artist.profile.nil?
      new_artist_profile_path(resource.artist.id)
    else
      user_path(current_user)
      #edit_artist_profile_path(resource.artist.id, resource.artist.profile.id)
    end
  end

  def after_sign_up_path_for(resource)
    if resource.artist.profile.nil?
      new_artist_profile_path(resource.artist.id)
    else
      edit_artist_profile_path(resource.artist.id, resource.artist.profile.id)
    end
  end

  private

  def user_coordinates_from_ip
    geo_obj = Geocoder.search("#{request.remote_ip}")[0]
    (geo_obj.latitude != 0.0 && geo_obj.longitude != 0.0) ? [geo_obj.latitude, geo_obj.longitude] : [23.7231, 90.4086]
  end

  def logged_in?
    user_signed_in?
  end

  def login_required
    unless logged_in?
      flash[:error] = 'login_required'
      redirect_to :new_user_session
      return
    end
  end

end

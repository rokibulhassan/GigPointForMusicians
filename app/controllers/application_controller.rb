class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path
  helper_method :user_coordinates_from_ip

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
      if resource.try(:artist).try(:profile).nil?
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

  def facebook_access_permission(permissions)
    session[:oauth] = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_SECRET_TOKEN'], "http://#{request.host_with_port}/users/callback")
    @auth_url = session[:oauth].url_for_oauth_code(:permissions => permissions)
  end

  private

  def user_coordinates_from_ip
    ip = request.remote_ip
    ip ||= request.env['REMOTE_ADDR']
    geo_obj = Geocoder.search(ip.to_s).first
    begin
      (geo_obj.latitude != 0.0 && geo_obj.longitude != 0.0) ? [geo_obj.latitude, geo_obj.longitude] : [1.3667, 103.8]
    rescue Exception => ex
      logger.error "Error occur while search location for client IP: #{ip} and Location: #{geo_obj.inspect}"
      [1.3667, 103.8]
    end
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

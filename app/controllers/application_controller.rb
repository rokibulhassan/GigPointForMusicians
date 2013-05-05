class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path
  helper_method :user_coordinates_from_ip

  def after_sign_in_path_for(resource)
    if resource.artist.profile.nil?
      new_artist_profile_path(resource.artist.id)
    else
      edit_artist_profile_path(resource.artist.id, resource.artist.profile.id)
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

end

class ApplicationController < ActionController::Base
  protect_from_forgery
  add_breadcrumb "Home", :root_path

  def after_sign_in_path_for(resource)
    if resource.artist.profile.nil?
    new_artist_profile_path(resource.artist.id)
    else
      root_url
    end
  end

  def after_sign_up_path_for(resource)
    if resource.artist.profile.nil?
      new_artist_profile_path(resource.artist.id)
    else
      root_url
    end
  end

end

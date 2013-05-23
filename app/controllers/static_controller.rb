class StaticController < ApplicationController
  def home
    if current_user
      @profile = current_user.artist.profile rescue {}
    end
  end
end

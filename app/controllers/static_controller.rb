class StaticController < ApplicationController
  def home
    if current_user
      @profile = current_user.profile
    end
  end
end

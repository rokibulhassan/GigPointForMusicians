class Venue < ActiveRecord::Base
  attr_accessible :about, :address, :country_id, :latitude, :longitude, :profile_id
  belongs_to :country
  belongs_to :profile


  def default_coordinates
    if latitude.present?
      [latitude, longitude] rescue []
    end
  end

end

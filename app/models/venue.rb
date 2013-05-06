class Venue < ActiveRecord::Base
  attr_accessible :about, :address, :country_id, :latitude, :longitude, :profile_id
  belongs_to :country
  belongs_to :profile
  has_many :gigs

  validates :address, :presence => {:message => "Venue address is required"}
  validates :latitude, :presence => {:message => "Venue latitude is required"}
  validates :longitude, :presence => {:message => "Venue longitude is required"}


  def default_coordinates
    if latitude.present?
      [latitude, longitude] rescue []
    end
  end

end

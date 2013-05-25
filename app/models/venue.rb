class Venue < ActiveRecord::Base
  attr_accessible :about, :name, :country_id, :latitude, :longitude, :profile_id, :address_attributes
  belongs_to :country
  belongs_to :profile
  has_many :gigs
  has_one :address, :as => :addressable

  accepts_nested_attributes_for :address
  validates :name, :presence => {:message => "Venue address is required"}
  #validates :latitude, :presence => {:message => "Venue latitude is required"}
  #validates :longitude, :presence => {:message => "Venue longitude is required"}


  def default_coordinates
    if latitude.present?
      [latitude, longitude] rescue []
    end
  end

  def self.auto_complete_results(p_params)
    venue_name = p_params[:term]
    venues = self.where(['name like ? ', "%#{venue_name}%"])
    venues
  end

end

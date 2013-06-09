class Venue < ActiveRecord::Base
  attr_accessible :description, :email, :tel, :url, :name, :lat, :lng, :city, :country, :address1, :address2, :address3,
                  :address4, :postcode, :state, :gig_ids
  belongs_to :profile
  has_many :gigs
  has_many :artists, :through => :gigs

  validates :name, :presence => {:message => "Venue address is required"}


  def default_coordinates
    if lat.present?
      [lat, lng] rescue []
    end
  end

  def self.auto_complete_results(p_params)
    venue_name = p_params[:term]
    venues = self.where(['name like ? ', "%#{venue_name}%"])
    venues
  end

end

class Gig < ActiveRecord::Base
  attr_accessible :created_by, :details, :duration, :email, :gig_type, :name, :price, :starts_at, :venue_id, :website_url,
      :others, :latitude, :longitude, :gmaps
  has_many :gig_artists
  has_many :artists, through: :gig_artists
  belongs_to :venue
end

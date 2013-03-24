class Artist < ActiveRecord::Base
  attr_accessible :profile_id,  :user_id
  belongs_to :user
  has_one :profile
  has_many :gig_artists
  has_many :gigs, through: :gig_artists
  has_many :artist_genres
  has_many :genres, through: :artist_genres

  accepts_nested_attributes_for :profile

  PROFILE_FIELDS = [:name, :user_name, :phone, :website_url, :bio]


end

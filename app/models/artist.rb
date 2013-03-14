class Artist < ActiveRecord::Base
  attr_accessible :profile_id
  has_one :profile
  has_many :gig_artists
  has_many :gigs, through: :gig_artists
  has_many :artist_genres
  has_many :genres, through: :artist_genres
end

class ArtistsGig < ActiveRecord::Base
  attr_accessible :artist_id, :gig_id
  belongs_to :artist
  belongs_to :gig
end

class Artist < ActiveRecord::Base
  attr_accessible :profile_id, :artist_profile, :profile, :user_id
  attr_accessor :profile
  belongs_to :user
  has_one :profile
  has_many :gig_artists
  has_many :gigs, through: :gig_artists
  has_many :artist_genres
  has_many :genres, through: :artist_genres

  accepts_nested_attributes_for :profile

  PROFILE_FIELDS = [:name, :user_name, :phone, :website_url, :bio]

  def profile
    Profile.where(:artist_id => id).last
  end

end

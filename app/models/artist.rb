class Artist < ActiveRecord::Base
  attr_accessible :profile_id, :user_id, :booking_contact, :user_name, :profile
  belongs_to :user
  has_one :profile, :dependent => :destroy
  has_many :gig_artists
  has_many :gigs, through: :gig_artists, :dependent => :destroy
  has_many :artist_genres
  has_many :genres, through: :artist_genres, :dependent => :destroy

  extend FriendlyId
  friendly_id :user_name, use: :slugged

  validates_uniqueness_of :user_name

  accepts_nested_attributes_for :profile

   mount_uploader :photo, PhotoUploader

  PROFILE_FIELDS = [:name, :user_name, :photo ,:phone, :website_url, :bio]

  scope :by_user_id, lambda { |user_id| where(user_id: user_id) }

end

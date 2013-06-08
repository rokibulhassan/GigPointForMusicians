class Artist < ActiveRecord::Base
  attr_accessible :gig_ids, :booking, :description, :email, :name, :tel, :url, :username, :user_id

  has_and_belongs_to_many :gigs
  belongs_to :user
  has_many :venues, :through => :gigs

  has_one :profile, :dependent => :destroy
  has_many :artists_gigs
  has_many :artist_genres
  has_many :genres, through: :artist_genres, :dependent => :destroy

  extend FriendlyId
  friendly_id :username, use: :slugged

  #validates_uniqueness_of :user_name

  accepts_nested_attributes_for :profile


  PROFILE_FIELDS = [:name, :user_name, :photo, :phone, :website_url, :bio]

  scope :by_user_id, lambda { |user_id| where(user_id: user_id) }

end

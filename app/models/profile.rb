class Profile < ActiveRecord::Base
  attr_accessible :name, :photo, :rating, :user_name, :website_url,
                  :provider, :uid, :bio, :remote_avatar_url, :phone, :address, :gender, :confirmed_at, :address, :user_id,
                  :artist_id, :profile_picture

  mount_uploader :profile_picture, PhotoUploader


  has_many :venues
  has_many :page_settings
  belongs_to :user
  belongs_to :artist
end

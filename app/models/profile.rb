class Profile < ActiveRecord::Base
  attr_accessible :name, :photo, :rating, :user_name, :website_url
  has_many :user_profiles
  has_many :users, through: :user_profiles
  has_many :venues
  has_many :page_settings
end

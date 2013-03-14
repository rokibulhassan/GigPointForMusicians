class Venue < ActiveRecord::Base
  attr_accessible :about, :address, :country_id, :lat, :lng, :profile_id
  belongs_to :country
  belongs_to :profile
end

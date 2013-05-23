class Genre < ActiveRecord::Base
  attr_accessible :name
  has_many :artist_genres
  has_many :artists, through: :artist_genres
end

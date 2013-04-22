class Gig < ActiveRecord::Base
  attr_accessible :created_by, :details, :duration, :email, :gig_type, :name, :price, :starts_at, :venue_id, :website_url,
                  :others, :latitude, :longitude, :gmaps, :extra_info, :artist_id
  attr_accessor :attr_venue, :artist_id

  has_many :gig_artists
  has_many :artists, through: :gig_artists
  belongs_to :venue

  after_create :create_gigs_artist
  before_save :create_gig_venue
  #
  #def default_coordinates
  #  if latitude.present?
  #    [latitude, longitude] rescue []
  #  end
  #end


  private

  def create_gig_venue
    logger.info ">>>>> Creating venue"
    self.create_venue!(self.attr_venue) if self.attr_venue.present?
  end

  def create_gigs_artist
    logger.info ">>>>> Creating gigs artist"
    GigArtist.create!(gig_id: self.id, artist_id: self.artist_id) if self.artist_id.present?
  end

end

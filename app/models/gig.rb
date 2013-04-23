class Gig < ActiveRecord::Base
  attr_accessible :created_by, :details, :duration, :email, :gig_type, :name, :price, :starts_at, :venue_id, :website_url,
                  :others, :latitude, :longitude, :gmaps, :extra_info, :artist_id, :free_entry
  attr_accessor :attr_venue, :attr_schedule_post, :artist_id, :free_entry

  has_many :gig_artists
  has_many :artists, through: :gig_artists
  belongs_to :venue
  belongs_to :user
  has_one :schedule_post

  after_create :create_gigs_artist
  before_save :manage_gig_venue, :manage_schedule_post
  before_validation :sync_price

  def gig_is_free?
    self.free_entry == "1" || self.price.to_f == 0.00
  end

  def post_immediately?
    self.schedule_post.post_immediately? && self.starts_at >= Date.today rescue false
  end

  def post_a_week_before?
    self.schedule_post.post_a_week_before? && Date.today > 1.week.until(self.starts_at) rescue false
  end

  def post_a_day_before?
    self.schedule_post.post_a_day_before? && Date.today >1.day.until(self.starts_at) rescue false
  end

  def post_the_day_off?
    self.schedule_post.post_the_day_off? && self.starts_at >= Date.today && DateTime.now.end_of_day rescue false
  end

  def self.post_to_social_network
    self.find_in_batches(batch_size: 1000) do |group|
      group.each do |gig|
        user = User.find(gig.created_by) rescue []
        if user.present?
          feed = {:message => 'Gig for fans.', :name => 'GigPoint', :link => "www.gigpoint.com", :description => 'Gig post from gig for musicians.'}
          if gig.post_immediately? || gig.post_a_week_before? || gig.post_a_day_before? || gig.post_the_day_off?
            user.publish_one_wall(feed)
          end
        end
      end
    end
  end

  private

  def manage_gig_venue
    logger.info ">>>>> Creating/Updating venue"
    if self.attr_venue.present?
      self.persisted? ? self.venue.update_attributes!(self.attr_venue) : self.create_venue!(self.attr_venue)
    end
  end

  def manage_schedule_post
    logger.info ">>>>> Creating/Updating Schedule Post"
    if self.attr_schedule_post.present?
      self.persisted? ? schedule_post.update_attributes!(attr_schedule_post) : create_schedule_post!(attr_schedule_post)
    end
  end


  def create_gigs_artist
    logger.info ">>>>> Creating gigs artist"
    GigArtist.create!(gig_id: self.id, artist_id: self.artist_id) if self.artist_id.present?
  end

  def sync_price
    self.price = 50.0 #TODO::Price is not introduced yet
    self.price = 0.00 if gig_is_free?
  end

end

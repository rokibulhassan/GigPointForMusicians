class Gig < ActiveRecord::Base
  attr_accessible :created_by, :details, :duration, :email, :gig_type, :name, :price, :starts_at, :venue_id, :website_url,
                  :others, :latitude, :longitude, :gmaps, :extra_info, :artist_id, :free_entry, :user_id, :schedule_post_attributes,
                  :venue_attributes, :selected_venue_id, :post_on_time_line, :post_in_groups
  attr_accessor :artist_id, :free_entry, :selected_venue_id, :post_on_time_line, :post_in_groups

  has_many :gig_artists
  has_many :artists, through: :gig_artists
  has_many :publish_histories
  belongs_to :venue
  belongs_to :user
  has_one :schedule_post

  accepts_nested_attributes_for :schedule_post, :venue

  after_create :create_gigs_artist
  after_save :post_to_social_media_now, :create_facebook_event, :post_on_facebook_time_line
  before_validation :sync_price, :set_selected_venue

  validates :name, :presence => {:message => "Gig name is required"}
  validates :starts_at, :presence => {:message => "Gig Start time is required"}
  validate :validates_others

  scope :up_coming_gigs, where('starts_at >= ?', Date.today)
  scope :past_gigs, where('starts_at <= ?', Date.today)


  def post_on_time_line?
    self.post_on_time_line == "1" rescue false
  end

  def post_in_groups?
    self.post_in_groups == "1" rescue false
  end

  def free_entry?
    self.free_entry == "1" rescue false
  end

  def gig_is_free?
    free_entry? || self.price.to_f == 0.00
  end

  def post_immediately?
    self.schedule_post.post_immediately? && self.starts_at.to_date >= Date.today rescue false
  end

  def post_a_week_before?
    self.schedule_post.post_a_week_before? && Date.today > 1.week.until(self.starts_at.to_date) rescue false
  end

  def post_a_day_before?
    self.schedule_post.post_a_day_before? && Date.today >1.day.until(self.starts_at.to_date) rescue false
  end

  def post_the_day_off?
    self.schedule_post.post_the_day_off? && self.starts_at.to_date >= Date.today && DateTime.now.end_of_day rescue false
  end

  def post_facebook?
    self.schedule_post.post_facebook?
  end

  def post_twitter?
    self.schedule_post.post_twitter?
  end

  def self.post_to_social_network
    logger.info "Executing cron task at #{Time.zone.now}"
    self.find_in_batches(batch_size: 1000) do |group|
      group.each do |gig|
        gig.post_to_social_media_now
      end
    end
  end

  def post_to_social_media_now
    if self.post_immediately? || self.post_a_week_before? || self.post_a_day_before? || self.post_the_day_off?
      message = "Gig #{self.name} for fans."
      feed = {:name => self.name, :link => "http://build.gig-point.com/gigs/#{self.id}", :description => 'Gig post from gig for musicians.'}
      status = "Tweeting as a gig name #{self.name}!"

      self.user.update_twitter_status(self.id, status) if self.post_twitter?
      if self.user.can_publish_to_page?
        self.user.user_profile.selected_fan_pages.each do |page|
          self.user.post_to_fan_page(self.id, page, message, feed) if self.post_facebook?
        end
      end
    end
  end

 # private

  def set_selected_venue
    self.venue_id = self.selected_venue_id if self.selected_venue_id.present?
  end

  def validates_others
    return true if free_entry?
    if others.empty? && !free_entry?
      self.errors.add(:base, "Must field others field if not free")
    end
  end

  def create_gigs_artist
    logger.info "Creating gigs artist for Gig #{self.name}"
    GigArtist.create!(gig_id: self.id, artist_id: self.artist_id) if self.artist_id.present?
  end

  def create_facebook_event
    if self.user.can_create_event?
      self.user.user_profile.selected_fan_pages.each do |page|
        page.create_facebook_event_for(self)
      end
    end
  end

  def post_on_facebook_time_line
    if self.user.can_publish_to_wall? && self.post_on_time_line?
      message = "Gig #{self.name} for fans."
      feed = {:name => self.name, :link => "http://build.gig-point.com/gigs/#{self.id}", :description => 'Gig post from gig for musicians.'}
      self.user.publish_one_wall(message, feed)
    end
  end

  def post_in_facebook_groups
    if self.user.can_publish_in_groups? && self.post_in_groups?
      feed = {:message => "Gig #{self.name} for fans.", :name => self.name, :link => "http://build.gig-point.com/gigs/#{self.id}", :description => 'Gig post from gig for musicians.'}
      self.user.user_profile.selected_user_groups.each do |group|
        self.user.post_in_groups(self.id, group, feed)
      end
    end
  end

  def sync_price
    self.price = 50.0 #TODO::Price is not introduced yet
    self.price = 0.00 if gig_is_free?
  end

end

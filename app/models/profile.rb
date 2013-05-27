class Profile < ActiveRecord::Base
  attr_accessible :name, :photo, :rating, :user_name, :website_url,
                  :provider, :uid, :bio, :remote_avatar_url, :phone, :address, :gender, :confirmed_at, :address, :user_id,
                  :artist_id, :profile_picture, :artist_attributes, :selected_page_id, :selected_group_id

  attr_accessor :artist_attributes

  serialize :selected_page_id, Array
  serialize :selected_group_id, Array

  mount_uploader :profile_picture, PhotoUploader


  has_many :venues
  has_many :page_settings
  belongs_to :user
  belongs_to :artist

  after_save :sync_artist_user_name

  validate :validate_after_persistence, if: Proc.new { |profile| !profile.user.nil? }
  #validates_uniqueness_of :user_name

  accepts_nested_attributes_for :artist

  def selected_user_groups
    return nil if selected_group_id == nil
    Group.where(id: selected_group_id)
  end

  def selected_fan_pages
    return nil if selected_page_id == nil
    Page.where(id: selected_page_id)
  end

  def selected_page
    return nil if selected_page_id == nil
    @page = Page.find_all_by_page_id selected_page_id
  end

  def user_picture
    remote_avatar_url.present? ? remote_avatar_url : photo.url
  end

  def page_selected?
    !selected_page.nil?
  end

  def validate_after_persistence
    fields = ["name", "website_url", "address"]
    if persisted?
      fields.each do |field|
        if send(field.to_sym).nil? || send(field.to_sym).strip.length < 1
          errors.add(:base, "#{field.humanize} required")
        end
      end
    end
  end

  def artist_validation
    if self.persisted?
      if artist.nil?
        errors.add :base, "Should have one artist"
      end
    end
  end

  private

  def sync_artist_user_name
    logger.info ">>>>>>>>>>>>Seting artist user name. "
    self.artist.update_attributes!(user_name: self.user_name)
  end

end

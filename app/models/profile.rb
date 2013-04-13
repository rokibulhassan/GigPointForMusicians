class Profile < ActiveRecord::Base
  attr_accessible :name, :photo, :rating, :user_name, :website_url,
                  :provider, :uid, :bio, :remote_avatar_url, :phone, :address, :gender, :confirmed_at, :address, :user_id,
                  :artist_id, :profile_picture, :artist_attributes, :selected_page_id

  attr_accessor :artist_attributes

  mount_uploader :profile_picture, PhotoUploader
  mount_uploader :photo, PhotoUploader

  before_validation :validate_after_persistence

  has_many :venues
  has_many :page_settings
  belongs_to :user
  belongs_to :artist

  accepts_nested_attributes_for :artist

  def selected_page
    return nil if selected_page_id == nil
    @page = Page.find_all_by_page_id selected_page_id
  end

  def page_selected?
    !selected_page.nil?
  end

  def validate_after_persistence
    if self.persisted?
      if name.nil?
        errors.add :base, "Name is required"
      end

      if website_url.strip.length < 1
        errors.add :base, "Website url is required"
      end
      if gender.nil?
        errors.add :base, "Website url is required"
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

end

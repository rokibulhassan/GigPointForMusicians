class Profile < ActiveRecord::Base
  attr_accessible :name, :photo, :rating, :user_name, :website_url,
                  :provider, :uid, :bio, :remote_avatar_url, :phone, :address, :gender, :confirmed_at, :address, :user_id,
                  :artist_id, :profile_picture, :artist_attributes, :selected_page_id

  attr_accessor :artist_attributes

  mount_uploader :profile_picture, PhotoUploader
  mount_uploader :photo, PhotoUploader


  has_many :venues
  has_many :page_settings
  belongs_to :user
  belongs_to :artist

  validate :validate_after_persistence, if: Proc.new {|profile| !profile.user.nil? }

  accepts_nested_attributes_for :artist

  def selected_page
    return nil if selected_page_id == nil
    @page = Page.find_all_by_page_id selected_page_id
  end

  def page_selected?
    !selected_page.nil?
  end

  def validate_after_persistence
    fields = ["name", "website_url", "address"]
    if persisted?
       fields.each do |field|
         if send(field.to_sym).nil? || send(field.to_sym).strip.length < 1
           errors.add(:base, "#{field.humanize} required" )
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

end

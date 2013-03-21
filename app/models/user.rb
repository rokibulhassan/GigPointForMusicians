class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :roles
  has_one :profile, :dependent => :delete
  has_many :page_settings
  has_many :authentications, :dependent => :delete_all

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
      profile_info = {
          name: auth.info.name,
          provider: auth.provider,
          uid: auth.uid,
          bio: auth.info.description || auth.extra.raw_info.quotes,
          remote_avatar_url: auth.info.image.to_s.gsub("square", "large"),
          phone: auth.info.phone,
          address: auth.info.location,
          gender: auth.extra.raw_info.gender,
          confirmed_at: Time.now
      }
     if user.profile.nil?
       @profile = user.build_profile(profile_info)
       @profile.save
     else
       @profile = user.profile
       @profile.update_attributes!(profile_info)
     end
    else
      user = User.where(:email => auth.info.email).first

      unless user
        user = create_user_from_facebook_oauth(auth)
      end
    end
    user
  end

  def self.create_user_from_facebook_oauth(auth)
    user = User.create(
           password: Devise.friendly_token[0, 20],
           email: auth.info.email
    )
    if user.persisted?
      profile_info = {
          name: auth.info.name,
          provider: auth.provider,
          uid: auth.uid,
          bio: auth.info.description || auth.extra.raw_info.quotes,
          remote_avatar_url: auth.info.image.to_s.gsub("square", "large"),
          phone: auth.info.phone,
          address: auth.info.location,
          gender: auth.extra.raw_info.gender,
          confirmed_at: Time.now
      }
      @profile =  user.build_profile(profile_info)
      @profile.save!
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.nickname + '@personlog.com').first
      unless user
        user = User.create(name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           bio: auth.info.description,
                           remote_avatar_url: auth.info.image.to_s.gsub("_normal", ""),
                           email: auth.info.nickname + '@personlog.com',
                           password: Devise.friendly_token[0, 20],
                           phone: auth.info.phone,
                           address: auth.info.location,
                           confirmed_at: Time.now
        )
      end
    end
    user
  end


end


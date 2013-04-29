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
  has_many :page_settings
  has_many :authentications
  has_one :artist, :dependent => :destroy
  has_many :pages
  has_many :gigs
  after_destroy :delete_authentications


  after_save :update_facebook_page

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
      if user.artist.nil?
        @artist = user.build_artist
        if @artist.save
          @profile = @artist.build_profile(profile_info)
          @profile.save!
        end
        if user.artist
          @profile = user.artist.profile if user.artist.profile
          @profile.update_attributes!(profile_info) if user.artist.profile
        end
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
    end
    if user.artist.nil?
      @artist = user.build_artist
      if @artist.save
        @profile = @artist.build_profile(profile_info)
        @profile.save!
      end
    else
      if user.artist
        @profile = user.artist.profile if user.artist.profile
        @profile.update_attributes!(profile_info) if user.artist.profile
      end
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

  def self.not_in?(current_user, provider)
    current_user.authentications.where(:provider => provider).length == 0
  end

  def have_facebook_credentials?
    authentications.collect(&:provider).include?('facebook')
  end

  def have_twitter_credentials?
    authentications.collect(&:provider).include?('twitter')
  end


  def page_selected? # true or false
    return false if !have_facebook_credentials?
    !page_setting.nil?
  end

  def have_facebook_pages
    !pages.empty?
  end

  def initiate_graph_api
    return nil if !have_facebook_credentials?
    @user_graph = Koala::Facebook::API.new(authentications.where(provider: "facebook", user_id: self.id).first.credentials) rescue nil
  end

  def initiate_twitter_api
    return nil if !have_twitter_credentials?
    credentials = authentications.where(provider: "twitter", user_id: self.id).last.credentials.split(" ") rescue nil
    @twitter_user = Twitter::Client.new(
        :oauth_token => credentials.first,
        :oauth_token_secret => credentials.last
    )
  end


  def update_facebook_page
    if have_facebook_credentials?
      @user_graph = self.initiate_graph_api
      if @user_graph
        # ["category", "name", "access_token", "id", "perms"]
        pages = @user_graph.get_connections('me', 'accounts')
        pages.each do |page|
          #:name, :page_id, :selected, :token, :user_id, :category, :perms
          begin
            new_page = self.pages.find_or_create_by_page_id(page['id'])
            new_page.update_attributes(name: page['name'], token: page['access_token'], category: page['category'], perms: page['perms'])
          rescue Exception => ex
            logger.info "Error occur while posting to facebook. #{ex.message}"
          end
        end
      end
    end
  end

  def update_twitter_status(status)
    if have_twitter_credentials?
      @twitter_user = self.initiate_twitter_api
      if @twitter_user
        begin
          @twitter_user.update(status)
        rescue Exception => ex
          logger.info "Error occur while updating twitter status. #{ex.message}"
        end
      end
    end
  end

  def permissions_for
    permissions = initiate_graph_api.get_connections('me', 'permissions').collect(&:keys).flatten
  end

  def can_publish_to_page?
    permissions_for.include?('manage_pages')
  end

  def can_publish_to_wall?
    permissions_for.include?('publish_stream')
  end

  def default_pages
    self.pages.active
  end

  def publish_one_wall(message, feed)
    begin
      @graph = initiate_graph_api
      @graph.put_wall_post(message, feed)
      true
    rescue Exception => ex
      logger.info "Error posting on Facebook::#{ex.message}"
      false
    end
  end

  def user_profile
    try(:artist).try(:profile)
  end

  def profile_picture
    user_profile.photo.url || user_profile.remote_avatar_url
  end

  def delete_authentications
    authentications.each(&:destroy)
  end


end


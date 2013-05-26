class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :roles
  has_many :page_settings
  has_many :authentications
  has_one :artist, :dependent => :destroy
  has_many :pages
  has_many :groups
  has_many :gigs
  after_destroy :delete_authentications


  after_save :update_facebook_page, :update_facebook_group

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    @profile_info = {
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

    #begin
    user = User.find_by_email(auth.info.email)  rescue nil
    if user.nil?
      user = User.create!(
          password: Devise.friendly_token[0, 20],
          email: auth.info.email
      )
    end

    artist = user.artist
    unless artist
    artist = Artist.create!(
        user_id: user.id
    )
    end
    if user.artist.try(:profile).nil?
      profile = Profile.find_by_artist_id(artist.id)
      if profile
        profile.update_attributes! @profile_info
      else
        @profile_info.merge!(artist_id: artist.id)
        profile = Profile.create(@profile_info)
      end
    else
      if artist.profile
        artist.profile.update_attributes! @profile_info
      end
    end
    puts "###########info###############"
    puts "############{user}###############"
    puts "############{user.artist}###############"
    puts "############{user.artist.profile}###############"
    puts "###########info###############"
    user
  end


  def self.create_user_from_facebook_oauth(auth, profile_info)
    user = User.create!(
        password: Devise.friendly_token[0, 20],
        email: auth.info.email
    )

    begin
      if user
        @artist = Artist.create!(user_id: user.id)
        @profile_info.merge!(artist_id: @artist.id)
        @profile = Profile.create!(@profile_info)
      else
        if user.artist
          @profile = user.artist.profile if user.artist.profile
          @profile.update_attributes!(@profile_info) if user.artist.profile
        end
      end
    rescue => e
      raise e.message.inspect
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
    @twitter_user = Twitter::Client.new(:oauth_token => credentials.first, :oauth_token_secret => credentials.last)
  end

  def update_facebook_page
    if have_facebook_credentials?
      @user_graph = self.initiate_graph_api
      if @user_graph
        begin
          pages = @user_graph.get_connections('me', 'accounts')
          pages.each do |page|
            new_page = self.pages.find_or_create_by_page_id(page['id'])
            new_page.update_attributes(name: page['name'], token: page['access_token'], category: page['category'], perms: page['perms'])
            logger.info "Creating/Updating facebook page :: #{page['name']}."
          end
        rescue Exception => ex
          logger.error "Error occur while Creating/Updating facebook page :: #{ex.message}"
        end
      end
    end
  end

  def update_facebook_group
    if have_facebook_credentials?
      @user_graph = self.initiate_graph_api
      if @user_graph
        begin
          groups = @user_graph.get_connections('me', 'groups')
          groups.each do |group|
            new_group = self.groups.find_or_create_by_group_id(group['id'])
            new_group.update_attributes(name: group['name'])
            logger.info "Creating/Updating facebook group :: #{group['name']}."
          end
        rescue Exception => ex
          logger.error "Error occur while Creating/Updating facebook group :: #{ex.message}"
        end
      end
    end
  end

  def update_twitter_status(gig_id, status)
    if have_twitter_credentials?
      @twitter_user = self.initiate_twitter_api
      if @twitter_user
        begin
          @twitter_user.update(status)
          PublishHistory.track_publish_history(gig_id, "twitter")
          logger.info "Gig id #{gig_id} posted on Twitter at #{Time.zone.now.strftime("%d %b %Y %H:%M:%S")}"
        rescue Exception => ex
          logger.error "Error occur while updating twitter status. #{ex.message}"
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

  def can_create_event?
    permissions_for.include?('create_event')
  end

  def can_publish_in_groups?
    permissions_for.include?('user_groups')
  end

  def default_pages
    self.pages.active
  end

  def publish_one_wall(message, feed)
    begin
      @graph = initiate_graph_api
      @graph.put_wall_post(message, feed)
      logger.info "Gig id #{gig_id} posted on Facebook Time Line at #{Time.zone.now.strftime("%d %b %Y %H:%M:%S")}"
    rescue Exception => ex
      logger.error "Error posting on Facebook::#{ex.message}"
    end
  end

  def post_to_fan_page(gig_id, page, message, feed)
    begin
      graph_page = Koala::Facebook::API.new(page.token)
      graph_page.put_wall_post(message, feed)
      PublishHistory.track_publish_history(gig_id, "facebook")
      logger.info "Gig id #{gig_id} posted on Facebook FanPage at #{Time.zone.now.strftime("%d %b %Y %H:%M:%S")}"
    rescue Exception => ex
      logger.error "Error occur while posting to facebook fan page. #{ex.message}"
    end
  end

  def post_in_groups(gig_id, group, feed)
    begin
      access_token = authentications.find_by_provider("facebook").credentials rescue []
      graph_group = FbGraph::User.new(group.group_id, access_token: access_token)
      graph_group.feed!(feed)
      PublishHistory.track_publish_history(gig_id, "facebook")
      logger.info "Gig id #{gig_id} posted on Facebook FanPage at #{Time.zone.now.strftime("%d %b %Y %H:%M:%S")}"
    rescue Exception => ex
      logger.error "Error occur while posting to facebook fan page. #{ex.message}"
    end
  end

  def user_profile
    try(:artist).try(:profile)
  end

  def artist_profile
    user_profile.artist rescue nil
  end

  def has_artist_profile?
    !artist_profile.nil?
  end

  def has_profile?
    !user_profile.nil?
  end

  def avatar
    has_profile? ? user_profile.user_picture : 'please upload your profile picture'
  end

  def name
    has_profile? ? user_profile.name : email
  end


  def profile_picture
    user_profile.photo.url || user_profile.remote_avatar_url
  end

  def delete_authentications
    authentications.each(&:destroy)
  end


end


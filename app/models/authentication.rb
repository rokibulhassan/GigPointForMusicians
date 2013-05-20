class Authentication < ActiveRecord::Base
  attr_accessible :credentials, :expired_at, :permissions, :provider, :raw, :uid, :user_id
  belongs_to :user

  after_save :sync_facebook_page

  private

  def sync_facebook_page
    self.user.update_facebook_page
  end
end

class Authentication < ActiveRecord::Base
  attr_accessible :credentials, :expired_at, :permissions, :provider, :raw, :uid, :user_id
  belongs_to :user

  after_save :sync_facebook_page_and_group

  private

  def sync_facebook_page_and_group
    self.user.update_facebook_page
    self.user.update_facebook_group
  end
end

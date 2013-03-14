class PageSetting < ActiveRecord::Base
  attr_accessible :category, :page_id, :page_name, :page_token, :perms, :user_id
  belongs_to :user
  belongs_to :profile
end

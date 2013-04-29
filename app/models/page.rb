class Page < ActiveRecord::Base
  attr_accessible :name, :page_id, :selected, :token, :user_id, :category, :perms
  belongs_to :user
  belongs_to :profile
end

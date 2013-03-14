class UserProfile < ActiveRecord::Base
  attr_accessible :profile_id, :user_id
  belongs_to :profile
  belongs_to :user
end

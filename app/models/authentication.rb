class Authentication < ActiveRecord::Base
  attr_accessible :credential, :expired_at, :permissions, :provider, :raw, :uid, :user_id
  belongs_to :user
end

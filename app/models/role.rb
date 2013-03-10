class Role < ActiveRecord::Base
  attr_accessible :role, :user_id
end

class SchedulePost < ActiveRecord::Base
  attr_accessible :gig_id, :user_id, :post_facebook, :post_twitter, :post_immediately, :post_a_week_before, :post_a_day_before, :post_the_day_off
  belongs_to :gig

  POST_AT = [post_immediately: "post immediately", post_a_week_before: "post a week before", post_a_day_before: "post a day before", post_the_day_off: "post the day off"]
end

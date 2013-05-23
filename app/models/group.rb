class Group < ActiveRecord::Base
  attr_accessible :name, :group_id, :user_id
  belongs_to :user
  belongs_to :profile

  def create_facebook_event_for(gig)
    logger.info "Creating Facebook Events #{gig.name} for group #{self.name}"
    access_token = self.user.authentications.find_by_provider("facebook").credentials rescue []
    group = FbGraph::User.new(self.group_id, access_token: access_token)
    event = group.event!(
        :name => "#{gig.name}@#{gig.venue.address}",
        :location => gig.venue.address,
        :start_time => Time.zone.today,
        :end_time => gig.starts_at.to_date
    )
  end
end

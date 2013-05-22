class Page < ActiveRecord::Base
  attr_accessible :name, :page_id, :selected, :token, :user_id, :category, :perms
  belongs_to :user
  belongs_to :profile

  def create_facebook_event_for(gig)
    logger.info "Creating Facebook Events #{gig.name} for page #{self.name}"
    page = FbGraph::User.me(self.token)
    event = page.event!(
        :name => "#{gig.name}@#{gig.venue.address}",
        :location => gig.venue.address,
        :start_time => Time.zone.today,
        :end_time => gig.starts_at.to_date
    )
  end
end

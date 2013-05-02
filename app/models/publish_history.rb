class PublishHistory < ActiveRecord::Base
  attr_accessible :gig_id, :provider, :posted_at
  belongs_to :gig

  def self.track_publish_history(gig_id, provider)
    logger.info ">>>>> Tracking published history."
    PublishHistory.create!(gig_id: gig_id, provider: provider, posted_at: Time.zone.now)
  end
end
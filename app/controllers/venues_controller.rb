class VenuesController < ApplicationController

  def auto_complete_for_venues
    venues = Venue.auto_complete_results(params)

    result = venues.collect do |venue|
      {id: venue.id,
       value: venue.address,
       latitude: venue.latitude,
       longitude: venue.longitude}
    end
    render json: result
  end

  def populate_location_map
    @venue = Venue.find(params[:venue_id])
  end

end

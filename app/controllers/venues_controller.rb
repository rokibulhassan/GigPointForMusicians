class VenuesController < ApplicationController


  def index
    venues = Venue.all

    result = venues.collect do |venue|
      {id: venue.id,
       value: venue.name,
       latitude: venue.latitude,
       longitude: venue.longitude,
       street: venue.try(:address).try(:street),
       city: venue.try(:address).try(:city),
       state: venue.try(:address).try(:state),
       country: venue.try(:address).try(:country),
       zip: venue.try(:address).try(:zip)
      }
    end
    render json: result
  end

  def auto_complete
    venues = Venue.auto_complete_results(params)

    result = venues.collect do |venue|
      {id: venue.id,
       value: venue.name,
       latitude: venue.latitude,
       longitude: venue.longitude}
    end
    render json: result
  end

  def populate_location_map
    @venue = Venue.find(params[:venue_id])
    @latitude = @venue.latitude
    @longitude = @venue.longitude
  end

end

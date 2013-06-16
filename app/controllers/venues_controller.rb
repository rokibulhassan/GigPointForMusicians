class VenuesController < ApplicationController


  def index
    venues = Venue.all

    result = venues.collect do |venue|
      {id: venue.id,
       value: venue.name,
       latitude: venue.lat,
       longitude: venue.lng,
       address: "#{venue.address1} #{venue.address2}  #{venue.address3}  #{venue.address4}",
       city: venue.try(:city),
       state: venue.try(:state),
       country: venue.try(:country),
       postcode: venue.try(:postcode)
      }
    end
    render json: result
  end

  def auto_complete
    venues = Venue.auto_complete_results(params)

    result = venues.collect do |venue|
      {id: venue.id,
       value: venue.name,
       latitude: venue.lat,
       longitude: venue.lng}
    end
    render json: result
  end

  def populate_location_map
    @venue = Venue.find(params[:venue_id])
    @latitude = @venue.lat
    @longitude = @venue.lng
  end

end

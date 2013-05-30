require 'grape-swagger'

module GigpointForMusician
  class API < Grape::API

    version 'v1', :using => :header, :vendor => 'GigpointForMusician'
    format :json

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :venues do

      desc "Return all venues."
      get do
        Venue.limit(20)
      end
    end

  end
end
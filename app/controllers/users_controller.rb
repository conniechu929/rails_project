class UsersController < ApplicationController
  def index
  end

  def create
  end

  def yelp
    parameters = { term: params[:term], limit: 16 }

    # render json: Yelp.client.search('San Francisco', parameters)
  end

  def somewhere
    puts "**********"
    puts params[:address]
    coords = Geocoder.coordinates(params[:address])
    puts coords[0]
    puts coords[1]
    puts "**********"
    redirect_to :back
  end
end

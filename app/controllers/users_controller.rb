class UsersController < ApplicationController
  def index
  end

  def create
  end

  def yelp
    parameters = { term: 'food', limit: 20 }

    # coordinates = {latitude:params[:lat], longitude:params[:long]}
    coordinates = {latitude:37.763945, longitude:-122.468449}
    @result = Yelp.client.search_by_coordinates(coordinates, parameters)

    # render json: Yelp.client.search('San Francisco', parameters)
  end
end

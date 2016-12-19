class UsersController < ApplicationController
  def index
  end

  def create
  end

  def yelp
    parameters = { term: params[:term], limit: 16 }

    # render json: Yelp.client.search('San Francisco', parameters)
  end
end

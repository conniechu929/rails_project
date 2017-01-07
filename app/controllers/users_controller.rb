class UsersController < ApplicationController
  before_action :require_login, except: [:index, :create, :login, :locate]
  before_action :photos_discard, only: [:index]
  def index
    if session[:coords]
      session.delete(:coords)
      @@discard_photos = []
    end
    if session[:destination]
      session.delete(:destination)
    end
  end

  def foodmatch
    if session[:coords].nil?
      redirect_to '/'
    else
     location = {latitude:session[:coords][0], longitude:session[:coords][1]}
     searchterms = ['food', 'american', 'asian-fusion', 'asian', 'japanese', 'italian', 'mexican', 'chinese', 'vietnamese', 'korean', 'bbq', 'french', 'german','russian', 'indian', 'seafood']
     r = Random.new
     term = { term: searchterms[r.rand(0...16)], categories: 'restaurants'}

         @results = search(term, location)

         session[:business_ids] =[]
         @results["businesses"].each do |result|
           session[:business_ids].push(result["id"])
         end

         randomBusId = session[:business_ids][r.rand(0...5)]

         @business = business(randomBusId)

         @randphotos = @business["photos"]
         @randphoto = @randphotos[r.rand(0..2)]

       if @@discard_photos.include?(@randphoto)
         newrandphoto = @randphotos[r.rand(0..2)]

         if newrandphoto != @randphoto
           @random = newrandphoto
         else
           @results = search(term, location)

            session[:business_ids] =[]
            @results["businesses"].each do |result|
              session[:business_ids].push(result["id"])
            end
            randomBusId = session[:business_ids][r.rand(0...5)]
            @business = business(randomBusId)
            @randphotos = @business["photos"]
            @random = @randphotos[r.rand(0..2)]
         end
       else
         @random = @randphoto
       end
     end
   end

   def swipe
     if params[:like]
       session[:destination] = params[:destination]
       session[:bus_id] = params[:bus_id]
       if place_check.blank?
         @place = Place.create(fave_params)
         Favorite.create(user_id:session[:user_id], place_id:@place["id"])
       else
         Favorite.create(user_id:session[:user_id], place_id:@place["id"])
       end
       redirect_to '/map'
     else
       @@discard_photos.push(params[:discard])
       redirect_to "/foodmatch/#{session[:user_id]}"
     end
   end

   def favorites
     if session[:user_id] == params[:user_id]
       @favorites = Favorite.where(user_id:session[:user_id])
     end

  #  def history
  #    puts "************"
  #    puts "PARAMS ID: ",params[:id]
  #    puts "SESSION ID: ",session[:user_id]
  #    puts "************"
  #    if params[:id].to_i == session[:user_id].to_i
  #      if !Place.exists?(1)
  #        flash[:history_error] = "Your History is empty"
  #      else
  #        @places = Place.where(user_id:session[:user_id])
  #      end
  #   end
  #  end

   def locate
     if session[:user_id].nil?
       redirect_to '/', flash: { login: true }
     else
       session[:address] = params[:address]
       session[:coords] = Geocoder.coordinates(params[:address])
       redirect_to "/foodmatch/#{session[:user_id]}"
     end
   end

   def map
     if session[:destination].nil?
       redirect_to '/'
     else
       @business_match = business(session[:bus_id])
     end
   end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  def fave_params
    params.require(:fave).permit(:business, :address, :city, :state)
  end
  def place_check
    @place = Place.find_by_address_and_city_and_state(params[:address], params[:city], params[:state])
  end
end

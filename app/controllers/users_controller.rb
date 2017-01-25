class UsersController < ApplicationController
  before_action :require_login, except: [:index, :create, :login, :locate]
  before_action :photos_discard, :coords_check, only: [:foodmatch]
  after_action :photos_length_check, only: [:pulling_photos]
  def index
    if session[:coords]
      session.delete(:coords)
    end
    if session[:destination]
      session.delete(:destination)
    end
  end

  def foodmatch
   generate_randomphoto
  #  returns @randphoto

   if @@discard_photos.include?(@randphoto)
     newrandphoto = @randphotos[r.rand(0..2)]
     #check if randphotos include any pics that our discard doesnt
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
        if @randphotos.length == 3
          @random = @randphotos[r.rand(0..2)]
        else
          foodmatch
        end
     end
   else
     @random = @randphoto
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
    if params[:id].to_i == session[:user_id].to_i
        @favorites = Favorite.where(user_id:session[:user_id])
    else
      redirect_to "/favorites/#{session[:user_id]}"
    end
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
       puts "Your address is", session[:address]
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


  def photos_length_check
    if @randphotos.length == 3
      @randphoto = @randphotos[r.rand(0..2)]
    end
  end

  def generate_randomphoto
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
    if @randphotos.length == 3
      @randphoto = @randphotos[r.rand(0..2)]
    else
      generate_randomphoto
    end
  end


end

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
       Place.create(business:params[:business], address:params[:address], city:params[:city], state:params[:state], user_id:session[:user_id])
       redirect_to '/map'
     else
       @@discard_photos.push(params[:discard])
       redirect_to "/foodmatch/#{session[:user_id]}"
     end
   end

   def history
     if session[:user_id] == params[:user_id]
       @places = Place.where(user_id:session[:user_id])
     end
   end

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

end

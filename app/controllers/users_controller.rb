class UsersController < ApplicationController
  before_action :require_login, except: [:index, :create, :login, :somewhere]
  def index
    if defined?(@@discard_photos).nil?
      @@discard_photos = []
    end
  end

  def create
    @user = User.create(user_params)
      if @user.errors.any?
        flash[:register_errors] = []
        @user.errors.full_messages.each do |message|
            if flash[:register_errors].include?(message) == false
              flash[:register_errors].push(message)
            end
        end
        redirect_to :back
      else
        session[:user_id] = @user.id
        redirect_to :back
      end
  end

  def login
    @user = User.find_by_email(params[:user][:email])
    flash[:register_errors] = []
    if User.find_by_email(params[:user][:email]).nil?
      flash[:register_errors].push("Email does not exist")
      redirect_to :back
    else
      if @user.authenticate(params[:user][:password]) == false
        flash[:register_errors].push("Invalid password")
        redirect_to :back
      else
        session[:user_id] = @user.id
        redirect_to :back
      end
    end
  end

def yelp
     location = {latitude:session[:coords][0], longitude:session[:coords][1]}
     searchterms = ['food', 'american', 'asian-fusion', 'asian', 'japanese', 'italian', 'mexican', 'chinese', 'vietnamese', 'korean', 'bbq', 'french', 'german','russian', 'indian', 'seafood']
     r = Random.new
     term = { term: searchterms[r.rand(0...16)], categories: 'restaurants'}

     if session[:coords] != nil
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
       redirect_to '/map'
     else
       @@discard_photos.push(params[:discard])
       redirect_to '/yelp'
     end
   end

  def somewhere
    if session[:user_id].nil?
      redirect_to '/', flash: { login: true }
    else
      session[:address] = params[:address]
      session[:coords] = Geocoder.coordinates(params[:address])
      redirect_to '/yelp'
    end
  end

  def logout
    reset_session
    redirect_to "/"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end

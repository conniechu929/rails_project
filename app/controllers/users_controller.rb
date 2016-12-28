class UsersController < ApplicationController
  before_action :require_login, except: [:index, :create, :login, :somewhere]
  def index

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
    searchterms = ['food', 'american', 'asian-fusion', 'asian', 'japanese', 'italian', 'mexican', 'chinese', 'vietnamese', 'korean', 'bbq', 'french', 'german','russian', 'indian', 'seafood'].shuffle
    term = { term: searchterms[0], categories: 'food'}

    if session[:coords] != nil

        @results = search(term, location)

        session[:business_ids] =[]
        @results["businesses"].each do |result|
          session[:business_ids].push(result["id"])
        end
        puts session[:business_ids]

        session[:business_ids].shuffle

        session[:photos] = []
        @business = business(session[:business_ids][0])
        session[:photos].push(@business["photos"])
        puts "********"
        puts session[:photos]
        puts "********"

        @randphotos = session[:photos][0].shuffle
        @random = @randphotos[0]
        puts "********"
        puts @randphotos
        puts "********"
    end
      # if session[:bus_id]
      #   session[:business_id].delete(session[:bus_id])
      # end
      # reset_session
  end

  def swipe
    if params[:like]
      session[:destination] = params[:destination]
      redirect_to '/map'
    else
      session[:bus_id] = []
      session[:bus_id].push(params[:bus_id])

      session[:photos].each do |photos|
        puts params[:discard]
        puts "*********"
        puts photos
        if photos.include?(params[:discard])
          photos.delete(params[:discard])
          puts "*~*~*~*~*~*~*~"
          puts photos
          puts "*~*~*~*~*~*~*~"
        end
      end
      # if @business_count.count(session[:bus_id]) == 3
      #   session[:bus_id]
      #   redirect_to '/yelp'
      # end
      redirect_to '/yelp'
    end

  end

  def map
  end


  def somewhere
    session[:address] = params[:address]
    session[:coords] = Geocoder.coordinates(params[:address])

    if session[:user_id].nil?
      redirect_to '/', flash: { login: true }
    else
      session[:address] = params[:address]
      session[:coords] = Geocoder.coordinates(params[:address])
      redirect_to '/yelp'
    end

    if session[:user_id].nil?
      puts "***********"
      puts "OLOLO"
      puts "***********"
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

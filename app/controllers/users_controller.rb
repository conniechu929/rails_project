class UsersController < ApplicationController
  def index

  end

  def create
    if params[:user][:name].to_s == '' || params[:user][:email].to_s == '' || params[:user][:password].to_s == '' && params[:user][:password] != params[:user][:password_confirmation]
      flash[:create_error] = "Fields can't be blank"
      flash[:error] = "Passwords do not match"
      redirect_to "/"
    elsif params[:user][:name].to_s == '' || params[:user][:email].to_s == '' || params[:user][:password].to_s == '' || params[:user][:password_confirmation].to_s == ''
      flash[:create_error] = "Fields can't be blank"
      redirect_to '/'
    elsif params[:user][:password] != params[:user][:password_confirmation]
      flash[:error] = "Passwords do not match"
      redirect_to '/'
    elsif params[:user][:password].length < 8
      flash[:error] = "Password is too short"
      redirect_to '/'
    else
      if params[:user][:password] == params[:user][:password_confirmation]
        @user = User.create(user_params)
        session[:user_id] = @user.id
        redirect_to "/yelp"
      end
    end
  end

  def login
    @user = User.find_by_email(params[:user][:email])
    if User.find_by_email(params[:user][:email]).nil?
      flash[:noemail] = "Email does not exist"
      redirect_to "/"
    else
      if @user.authenticate(params[:user][:password]) == false
        flash[:error] = "Invalid"
        redirect_to "/"
      else
        session[:user_id] = @user.id
        redirect_to "/yelp"
      end
    end
  end

  def yelp
    searchterms = ['food', 'restaurant', 'american', 'asian-fusion', 'asian', 'japanese', 'italian', 'mexican', 'chinese', 'vietnamese', 'korean', 'bbq', 'french', 'german','russian', 'indian'].shuffle
    term = { term: searchterms[0]}
    # params = { term: 'food', limit: 20}
    if session[:coords] != nil
      location = {latitude:session[:coords][0], longitude:session[:coords][1]}
      # coordinates = {latitude:session[:coords][0], longitude:session[:coords][1]}
      # @results = Yelp.client.search_by_coordinates(coordinates, params)

      @results = search(term, location)

      # @images = []
      # @results.businesses.each do |result|
      #   business(result.id)["photos"].each do |photo|
      #     @images.push(photo)
      #   end
      # end
      # @results["businesses"].each do |result|
      #   business(result["id"])["photos"].each do |photo|
      #     @images.push(photo)
      #   end
      # end
      # @limit = @results["businesses"].take(20)

      session[:business_id] =[]
      @results["businesses"].each do |result|
        session[:business_id].push(result["id"])
      end
      puts session[:business_id]

      @id = session[:business_id].shuffle

      session[:photos] = []
      # @photos = []
      @business = business(@id[0])

      photo = @business["photos"]
      session[:photos].push(photo)

      @randphoto = session[:photos][0].shuffle
      @random = @randphoto[0]
      # reset_session
    end
  end

  def map
    # location = {latitude:session[:coords][0], longitude:session[:coords][1]}
    # puts "***********"
    # puts session[:address]
    # puts "***********"
  end

  def somewhere
    if session[:user_id].nil?
      redirect_to '/', flash: { login: true }
    else
      session[:address] = params[:address]
      session[:coords] = Geocoder.coordinates(params[:address])
      redirect_to '/map'
    end
  end

  def logout
    reset_session
    redirect_to "/"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end

class UsersController < ApplicationController
  def index
    
  end

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
    parameters = { term: 'food', limit: 20 }
    if session[:coords] != nil
      coordinates = {latitude:session[:coords][0], longitude:session[:coords][1]}
      @result = Yelp.client.search_by_coordinates(coordinates, parameters)
  end


  def somewhere
    puts "**********"
    puts params[:address]
    session[:coords] = Geocoder.coordinates(params[:address])
    puts session[:coords][0]
    puts session[:coords][1]
    puts "**********"
    redirect_to '/users'
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

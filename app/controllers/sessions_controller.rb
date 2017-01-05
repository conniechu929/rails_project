class SessionsController < ApplicationController
  before_action :require_login, except: [:index, :create, :login]

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

  def logout
    reset_session
    redirect_to "/"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

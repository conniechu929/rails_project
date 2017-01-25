class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to '/' if session[:user_id] == nil
  end

  def coords_check
    if session[:coords].nil?
      redirect_to '/'
    end
  end

  def photos_discard
    if defined?(@@discard_photos).nil?
      @@discard_photos = []
    end
  end

  helper_method :current_user
  protect_from_forgery with: :exception
end

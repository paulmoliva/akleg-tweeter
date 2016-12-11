class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  private
  def current_user
    @current_user ||= User.where(session_token:session[:session_token]).first
  end

  def signed_in?
    !!current_user
  end


end

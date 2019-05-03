class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil if session[:session_token].nil?
    User.find_by_session_token(session[:session_token])
  end

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def signed_in
    redirect_to cats_url if current_user
  end

  def not_logged_in
    redirect_to new_session_url unless current_user
  end
end

class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:username], params[:password])

    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else
      flash.now[:error] = 'A user with that name and password does not exist'
      render :new
    end
  end

  def destroy
  end
end

class UsersController < ApplicationController
  before_action :signed_in, only: [:create, :new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:error] = @user.errors
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
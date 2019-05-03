class CatsController < ApplicationController
  helper_method :is_owner?
  before_action :not_logged_in, only: [:edit, :update, :new, :create]
  before_action :not_cat_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find_by_id(params[:id])

    if @cat
      @rentals = @cat.cat_rental_requests.order(start_date: :asc, end_date: :asc)
      render :show
    else
      redirect_to cats_url
    end
  end

  def edit
    @cat = Cat.find_by_id(params[:id])

    render :edit
  end

  def update
    @cat = Cat.find_by_id(params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = @cat.errors
      render :edit
    end
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = @cat.errors
      render :new
    end
  end

  def not_cat_owner
    return if is_owner?
    flash[:error] = "Only the cat's owner may update it"
    redirect_to cat_url(params[:id])
  end

  def is_owner?
    !current_user.cats.find_by_id(params[:id]).nil?
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end
end
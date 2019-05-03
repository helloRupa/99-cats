class CatsController < ApplicationController
  before_action :not_logged_in, only: [:edit, :update, :new, :create]

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

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = @cat.errors
      render :new
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end
end
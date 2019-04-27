class CatRentalRequestsController < ApplicationController
  def new
    @rental = CatRentalRequest.new
    @cats = Cat.all

    render :new
  end

  def create
    @rental = CatRentalRequest.new(rental_params)
    @cats = Cat.all

    if @rental.save
      redirect_to cat_url(@rental.cat_id)
    else
      flash[:error] = @rental.errors
      render :new
    end
  end

  private

  def rental_params
    params.require(:rental).permit(:cat_id, :start_date, :end_date, :status)
  end
end
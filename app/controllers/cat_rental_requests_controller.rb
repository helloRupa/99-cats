class CatRentalRequestsController < ApplicationController
  def new
    if params.key?(:cat_id)
      @rental = CatRentalRequest.new(cat_id: params[:cat_id])
    else
      @rental = CatRentalRequest.new
    end
    
    @cats = Cat.all

    flash[:error] = nil
    render :new
  end

  def create
    @rental = CatRentalRequest.new(rental_params)
    @cats = Cat.all

    if @rental.save
      redirect_to cat_url(@rental.cat_id)
    else
      flash[:error] = ['All fields are required', 'Start date must be in the future and before end date', 'Dates must not conflict with an existing approved rental']
      render :new
    end
  end
  
  def approve
    @rental = CatRentalRequest.find_by_id(params[:id])
    @rental.approve!

    redirect_to cat_url(@rental.cat_id)
  end

  def deny
    @rental = CatRentalRequest.find_by_id(params[:id])
    @rental.deny!

    redirect_to cat_url(@rental.cat_id)
  end

  private

  def rental_params
    params.require(:rental).permit(:cat_id, :start_date, :end_date)
  end
end
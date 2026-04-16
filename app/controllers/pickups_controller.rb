class PickupsController < ApplicationController

  def new
    @pickup = Pickup.new
  end

  def create
    @pickup = Pickup.new(pickup_params)
  end

  private

  def pickup_params
    params.require(:pickup).permit(:start, :end, :location, :link)
  end
end

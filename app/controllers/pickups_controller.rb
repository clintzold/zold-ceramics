class PickupsController < ApplicationController

  def new
    @pickup = Pickup.new
  end

  def create
    @pickup = Pickup.create(pickup_params)
   # respond_to do |format|
   #   if @pickup.errors.any?
   #     format.turbo_stream {
   #     render turbo_stream: turbo_steam.update(
   #       "pickup_form_errors", partial: "shared/form_errors", locals: { errors: @pickup.errors }
   #     ), status: :unprocessable_content
   #     }
    end
  end

  def destroy
    @pickup = Pickup.find(params[:id])
  end

  private

  def pickup_params
    params.require(:pickup).permit(:start, :end, :location, :link)
  end
end

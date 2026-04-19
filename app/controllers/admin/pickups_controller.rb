class Admin::PickupsController < Admin::BaseController
  def index
    @pickups = Pickup.all
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "pickups", partial: "index", locals: { pickups: @pickups }
        )
      }
    end
  end

  def new
    @pickup = Pickup.new
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "pickups", partial: "new", locals: { pickup: @pickup }
        )
      }
    end
  end

  def create
    @pickup = Pickup.create(pickup_params)
    respond_to do |format|
      if @pickup.errors.any?
        format.turbo_stream {
        render turbo_stream: turbo_steam.update(
          "pickup_form_errors", partial: "shared/form_errors", locals: { errors: @pickup.errors }
        ), status: :unprocessable_content
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "pickups", partial: "show", locals: { pickup: @pickup }
          )
        }
      end
    end
  end

  def partial
    render turbo_stream: turbo_stream.update("pickups", partial: "pickups")
  end

  def edit
    @pickup = Pickup.find(params[:id])
    render turbo_stream: turbo_stream.update(
      "pickups", partial: "new", locals: { pickup: @pickup }
    )
  end

  def show
    @pickup = Pickup.find(params[:id])
    render turbo_stream: turbo_stream.update(
      "pickups", partial: "show", locals: { pickup: @pickup }
    )
  end

  def destroy
    @pickup = Pickup.find(params[:id])
  end

  private

  def pickup_params
    params.require(:pickup).permit(:date, :details, :start, :end, :location, :link)
  end
end

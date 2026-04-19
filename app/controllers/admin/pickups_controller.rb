class Admin::PickupsController < Admin::BaseController
  def index
    @pickups = Pickup.where(created_at: Time.current..)
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
      "pickups", partial: "edit", locals: { pickup: @pickup }
    )
  end

  def update
    @pickup = Pickup.find(params[:id])
    if @pickup.update(pickup_params)
      render turbo_stream: turbo_stream.update(
        "pickups", partial: "show", locals: { pickup: @pickup }
      )
    else
      render turbo_stream: turbo_stream.update(
        "pickup_form_errors", partial: "shared/form_errors", locals: { errors: @pickup.errors }
      ), status: :unprocessable_content
    end
  end

  def show
    @pickup = Pickup.find(params[:id])
    render turbo_stream: turbo_stream.update(
      "pickups", partial: "show", locals: { pickup: @pickup }
    )
  end

  def confirm_cancel
    @pickup = Pickup.find(params[:id])
    render turbo_stream: turbo_stream.update(
      "modal", partial: "confirm_cancel", locals: { pickup: @pickup }
    )
  end

  def destroy
    @pickup = Pickup.find(params[:id])
    @recipients = []
    @pickup.orders.each {|order| @recipients << { email: order.email, name: order.name } }
    @pickup.destroy
    
    render turbo_stream: turbo_stream.update("pickups", partial: "pickups")
  end

  private

  def pickup_params
    params.require(:pickup).permit(:date, :details, :start, :end, :location, :link)
  end
end

class PagesController < ApplicationController
  allow_unauthenticated_access
  before_action :set_subscribe_modal_status, only: [:shop]

  def home
  end

  def about
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("about_details", partial: "about_info") }
      format.html { redirect_to home_path( anchor: "about" )}
    end
  end

  def shop
    @subscription = Subscription.new
   
    # Query for all in stock products, along with attachments and
    # their variants to avoid N+1 queries.
    #
    @products = Product.includes(main_image_attachment: {blob: :variant_records}, images_attachments: { blob: :variant_records }).where(out_of_stock: false)
  end

  private

  def set_subscribe_modal_status
    # Checks if subscribe modal cookie already exists
    @show_modal = cookies.signed[:modal_shown].blank?

    if @show_modal
      # Set cookie to expire in 1 week
      cookies.signed[:modal_shown] = {
        value: 'true',
        expires: 1.week.from_now,
        httponly: true
      }
    end
  end
end

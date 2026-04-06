class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
  end

  def about
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("about_details", partial: "about_info") }
      format.html { redirect_to home_path( anchor: "about" )}
    end
  end

  def shop
    @products = Product.with_attached_images.includes(
      images_attachments: { blob: :variant_records }, 
    ).with_attached_main_image.includes(
      main_image_attachment:{blob: :variant_records}
    ).where(out_of_stock: false)
  end
end

class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
  end

  def about
  end

  def shop
    @products = Product.includes(images_attachments: [blob: {variant_records: :blob}], main_image_attachment: [blob: :variant_records]).where(out_of_stock: false)
  end
end

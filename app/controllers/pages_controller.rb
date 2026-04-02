class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
  end

  def about
  end

  def shop
    @products = Product.where(out_of_stock: false)
  end
end

class PagesController < ApplicationController
  def home
  end

  def about
  end

  def shop
    @products = Product.all
  end
end

class AdminController < ApplicationController
  def dashboard
    @admin = Current.user
  end

  def products
    @products = Product.all
  end

  private
end

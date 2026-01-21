class AdminController < ApplicationController
  before_action :require_admin
  def dashboard
    @admin = Current.user
  end

  def products
    @products = Product.all
  end

  private
end

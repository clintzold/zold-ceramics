class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def dashboard
    @admin = current_user
  end

  def products
    @products = Product.all
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end
end

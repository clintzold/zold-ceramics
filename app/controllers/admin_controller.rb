class AdminController < ApplicationController
  def dashboard
    @admin = Current.user
  end
end

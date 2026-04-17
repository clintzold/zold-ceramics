class Admin::ChartsController < ApplicationController

  def orders_by_year
    render json: Order.group_by_month(:created_at, range: Time.new(2026, 1, 1, 0, 0, 0)..Time.new(2026, 12, 31, 23, 59, 0), format: "%b").sum(:total)
  end
end

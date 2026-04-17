class Admin::ChartsController < ApplicationController
  before_action :set_year

  def orders
    render json: Order.group_by_month(:created_at, range: Time.new(@year, 1, 1, 0, 0, 0)..Time.new(@year, 12, 31, 23, 59, 0), format: "%b").sum(:total)
  end

  def products
    range = Time.new(@year).beginning_of_year..Time.new(@year).end_of_year
    render json: OrderItem.where(created_at: range).group(:category).count
  end

  def filter
    render turbo_stream: turbo_stream.update("charts", partial: "charts", locals: { year: @year})
  end

  private

  def set_year
    if params[:year].present?
      @year = params[:year]
    else
      @year = Time.now.year
    end
  end
end

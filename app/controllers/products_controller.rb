class ProductsController < ApplicationController
  before_action :product_params, only: [ :create ]
  def shop
    @products = Product.all
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      @products = Product.all
      render :index, alert: "Product '#{@product.title}' succesfully created!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def delete
    @product.destroy
  end

  private

  def product_params
    params.expect(product: [ :title, :description, :price, :stock ])
  end
end

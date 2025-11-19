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
      redirect_to new_product_path, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def delete
    @product = Product.find(params[:id])
    @product.destroy
  end

  private

  def product_params
    params.expect(product: [ :title, :description, :price, :stock ])
  end
end

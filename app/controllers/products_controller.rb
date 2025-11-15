class ProductsController < ApplicationController
  def shop
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new
    if @product.save
    else
    end
  end

  def delete
    @product.destroy
  end
end

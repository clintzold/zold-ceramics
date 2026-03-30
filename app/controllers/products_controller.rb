class ProductsController < ApplicationController
  allow_unauthenticated_access only: [ :shop, :show ]
  before_action :product_params, only: [ :create ]

  def shop
    @products = Product.where(out_of_stock: false)
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

    result = ProductService::Create.call(@product)
    if result.success?
      flash[:success] = "Product was successfully created."  # FLASH NOT WORKING IN TURBO FRAME
      redirect_to new_product_path
    else
      flash.now[:danger] = result.errors.join(", ") # FLASH NOT WORKING IN TURBO FRAME
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "Product #{@product.title} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy!
      redirect_to admin_path, success: "Product was successfully deleted."
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def product_params
    params.expect(product: [ :title, :category, :description, :price, :stock, :weight, :height, :length, :width, :main_image, images: [] ])
  end
end

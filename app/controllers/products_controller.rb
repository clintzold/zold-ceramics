class ProductsController < ApplicationController
  before_action :product_params, only: [ :create ]
  before_action :validate_admin, only: [ :create, :new, :edit, :index, :update, :destroy ]

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

    begin
      stripe_product = Stripe::Product.create({
        name: @product.title,
        description: @product.description
      })
      stripe_price = Stripe::Price.create({
        unit_amount: @product.price.to_i * 100,
        currency: "cad",
        product: stripe_product.id
      })

      @product.stripe_product_id = stripe_product.id
      @product.stripe_price_id = stripe_price.id

      if @product.save
        redirect_to new_product_path, notice: "Product was successfully created."
      else
        render :new, status: :unprocessable_content
      end

    rescue Stripe::StripeError => e
      flash[:error] = "Error creating Stripe product: #{e.message}"
      render :new
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
    @product.delete
    redirect_to admin_path, notice: "Product was successfully deleted."
  end

  private

  def product_params
    params.expect(product: [ :title, :description, :price, :stock, :main_image, images: [] ])
  end

  def validate_admin
    if !current_user.admin
      redirect_to home_path, alert: "You do not have permission to access this page."
    end
  end
end

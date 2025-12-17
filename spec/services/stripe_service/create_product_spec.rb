
RSpec.describe StripeService::CreateProduct, type: :service do
  product = Product.new(
    title: "Test Product",
    description: "This is a test",
    price: 10,
    stock: 10
  )

  context "#initialize" do
    service = StripeService::CreateProduct.new(product)
    stripe_product_id = service.product.stripe_product_id
    stripe_price_id = service.product.stripe_price_id

    it "has a nil value for stripe_product_id" do
      expect(stripe_product_id).to be(nil)
    end
    it "has a nil value to stripe_price_id" do
      expect(stripe_price_id).to be(nil)
    end
    it "receives a product with attributes intact" do
      expect(service.product.title).to eq("Test Product")
    end
  end

  context "#call" do
    service = StripeService::CreateProduct.new(product)

    it "gives product a value for stripe_product_id" do
      expect { service.call }.to change(product, :stripe_product_id)
    end
    it "gives product a value for stripe_price_id" do
      expect { service.call }.to change(product, :stripe_price_id)
    end
    it "persists product to database(receives an ID on commit)" do
      service.call
      expect(product.id).not_to be(nil)
    end
  end
end

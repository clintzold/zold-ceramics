# spec/services/product/create_spec.rb
RSpec.describe ProductService::Create, type: :service do
  describe "#call" do
    context "when product is passed valid params" do
      before(:example) do
        params = {
          title: "test",
          description: "test",
          price: 10,
          stock: 10,
          stripe_product_id: "test_stripe_product_id",
          stripe_price_id: "test_stripe_price_id"
        }

        service = ProductService::Create.new(params)
        allow(service).to receive(:create_stripe_product).and_return(true)
        allow(service).to receive(:create_stripe_price).and_return(true)
        allow(service).to receive(:assign_stripe_attributes).and_return(true)
        @result = service.call
      end

      it "returns a Struct object" do
        expect(@result).to be_kind_of(Struct)
      end
      it "returns a Struct where success? is true" do
        expect(@result.success?).to be(true)
      end
      it "returns a payload" do
        expect(@result.payload).not_to be(nil)
      end
      it "has an errors array that is empty" do
        expect(@result.errors.empty?).to be(true)
      end
    end
    context "when product is passed invalid params" do
      before(:example) do
        params = {
          title: "test",
          description: "test",
          price: nil, # invalid value
          stock: 10,
          stripe_product_id: "test_stripe_product_id",
          stripe_price_id: "test_stripe_price_id"
        }

        service = ProductService::Create.new(params)
        allow(service).to receive(:create_stripe_product).and_return(true)
        allow(service).to receive(:create_stripe_price).and_return(true)
        allow(service).to receive(:assign_stripe_attributes).and_return(true)
        @result = service.call
      end

      it "returns a Struct object" do
        expect(@result).to be_kind_of(Struct)
      end
      it "returns a Struct where success? is false" do
        expect(@result.success?).to be(false)
      end
      it "returns a payload of nil" do
        expect(@result.payload).to be(nil)
      end
      it "returns a Struct with an array of errors" do
        expect(@result.errors).to be_kind_of(Array)
      end
      it "has an errors array that is not empty" do
        expect(@result.errors.empty?).to be(false)
      end
    end
    context "when Stripe raises an error" do
      it "rescues the error with a failure" do
      end
    end
  end
end

# spec/services/order_service/add_item_spec.rb
RSpec.describe OrderService::AddItem, type: :service do
  order = Order.new

  context "When an item doesn't have enough stock" do
    product = Product.create!(
        title: "test",
        description: "test",
        price: 10,
        stock: 1
      )
      service = described_class.new(
        order: order,
        product_id: product.id,
        desired_amount: 2
      )

    it "raises a NotEnoughStockError" do
      expect { service.call }.to raise_error(NotEnoughStockError)
    end
    it "does not decrement the stock value" do
      expect(product.reload.stock).to eq(1)
    end
  end

  context "When an item has enough stock" do
    product = Product.create!(
        title: "test",
        description: "test",
        price: 10,
        stock: 2
      )
      service = described_class.new(
        order: order,
        product_id: product.id,
        desired_amount: 2
      )

      service.call

    it "adds item to the order" do
      expect(order.order_items.any?).to be(true)
    end
    it "decrements the product's stock value" do
      expect(product.reload.stock).to eq(0)
    end
  end

  context "When a product cannot be found" do
    it "raises an ActiveRecord::RecordNotFound error" do
      expect {
        described_class.new(
          order: order,
          product_id: 10,
          desired_amount: 2
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

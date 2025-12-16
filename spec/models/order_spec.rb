require 'rails_helper'

RSpec.describe Order, type: :model do
  product = Product.create!(
            title: "Test",
            description: "test",
            price: 12.99,
            stock: 100
          )
    order = Order.create!

  context "When an order is created" do
    it "has a status of 'pending'" do
      expect(order.status).to eq("pending")
    end
  end
  context "When an order's status changes" do
    it "responds to enum values" do
      order.update(status: 1)
      expect(order.status).to eq("paid")
    end
  end
end

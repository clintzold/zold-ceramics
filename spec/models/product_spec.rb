require 'rails_helper'

RSpec.describe Product, type: :model do
    subject {
      Product.create!(
        title: "Test Product",
        description: "This is a test",
        price: 12.99,
        stock: 10
      )
    }
  context "when a Product is created" do
      it "is valid to save to DB with required attributes" do
        expect(subject).to be_valid
      end
      it "is not valid without a title" do
        subject.title = nil
        expect(subject).to_not be_valid
      end
      it "is not valid without stock value" do
        subject.stock = nil
        expect(subject).to_not be_valid
      end
    end

    context "When an product's attributes are updated" do
      it "updates out_of_stock value to true when stock updates to 0" do
        subject.update(stock: 0)
        expect(subject.out_of_stock).to be true
      end
      it "updates out_of_stock to false when stock is added again" do
        subject.update(stock: 0)
        subject.update(stock: 10)
        expect(subject.out_of_stock).to be false
      end
    end
    context "When return_stock is called" do
      xit "increments the stock" do
        subject.return_stock(10)
        expect(subject.reload.stock).to eq(20)
      end
      xit "increments the stock correctly during race conditions" do
        concurrency_level = 11
        wait_for_it = true
        threads = concurrency_level.times.map do |i|
          Thread.new do
            true while wait_for_it
            subject.return_stock(1)
          end
        end
        wait_for_it = false
        threads.each(&:join)
        expect(subject.reload.stock).to eq(21)
      end
    end
end

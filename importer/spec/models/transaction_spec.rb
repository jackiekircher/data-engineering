require 'spec_helper'

describe Transaction do

  describe "#total_price" do

    let(:item) do
      Item.new(price: rand(100))
    end

    let(:quantity) do
      rand(10)
    end

    it "multiplies the item price by the quantity" do

      t = Transaction.new(item: item, quantity: quantity)
      expect(t.total_price).to eq item.price * quantity
    end
  end
end

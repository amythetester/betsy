require "test_helper"

describe Orderitem do
  let(:orderitem) { orderitems(:trick) }

  it "must be valid" do
    value(orderitem).must_be :valid?
  end

  it "must be a valid order_item" do
    valid_orderitem = orderitem.valid?
    expect(valid_orderitem).must_equal true
  end

  describe "validations" do
    it "requires quantity" do
      orderitem.quantity = nil
      valid_orderitem = orderitem.valid?

      expect(valid_orderitem).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_include "can't be blank"
    end
  end

  describe "relationships" do
    it "must respond to product" do
      expect(orderitem).must_respond_to :product
    end

    it "must respond to order" do
      expect(orderitem).must_respond_to :order
    end
  end

  describe "custom quantity invalid method" do
    it "will return false if quantity is less than stock" do
    end

    it "will return false if quantity is equal to stock" do
    end

    it "will return true if quantity larger than stock" do
    end
  end

  describe "custom calculate cost method" do
  end

  describe "custom add quantity method" do
  end
end

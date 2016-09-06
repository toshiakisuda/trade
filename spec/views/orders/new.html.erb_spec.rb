require 'rails_helper'

RSpec.describe "orders/new", type: :view do
  before(:each) do
    assign(:order, Order.new(
      :stock_id => 1,
      :buy => 1.5,
      :sell => 1.5,
      :volume => 1
    ))
  end

  it "renders new order form" do
    render

    assert_select "form[action=?][method=?]", orders_path, "post" do

      assert_select "input#order_stock_id[name=?]", "order[stock_id]"

      assert_select "input#order_buy[name=?]", "order[buy]"

      assert_select "input#order_sell[name=?]", "order[sell]"

      assert_select "input#order_volume[name=?]", "order[volume]"
    end
  end
end

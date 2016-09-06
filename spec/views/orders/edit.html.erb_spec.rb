require 'rails_helper'

RSpec.describe "orders/edit", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
      :stock_id => 1,
      :buy => 1.5,
      :sell => 1.5,
      :volume => 1
    ))
  end

  it "renders the edit order form" do
    render

    assert_select "form[action=?][method=?]", order_path(@order), "post" do

      assert_select "input#order_stock_id[name=?]", "order[stock_id]"

      assert_select "input#order_buy[name=?]", "order[buy]"

      assert_select "input#order_sell[name=?]", "order[sell]"

      assert_select "input#order_volume[name=?]", "order[volume]"
    end
  end
end

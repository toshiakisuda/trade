require 'rails_helper'

RSpec.describe "prices/new", type: :view do
  before(:each) do
    assign(:price, Price.new(
      :stock_id => 1,
      :open => 1,
      :close => 1,
      :high => 1,
      :low => 1,
      :volume => 1,
      :market_cap => 1
    ))
  end

  it "renders new price form" do
    render

    assert_select "form[action=?][method=?]", prices_path, "post" do

      assert_select "input#price_stock_id[name=?]", "price[stock_id]"

      assert_select "input#price_open[name=?]", "price[open]"

      assert_select "input#price_close[name=?]", "price[close]"

      assert_select "input#price_high[name=?]", "price[high]"

      assert_select "input#price_low[name=?]", "price[low]"

      assert_select "input#price_volume[name=?]", "price[volume]"

      assert_select "input#price_market_cap[name=?]", "price[market_cap]"
    end
  end
end

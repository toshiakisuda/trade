require 'rails_helper'

RSpec.describe "prices/edit", type: :view do
  before(:each) do
    @price = assign(:price, Price.create!(
      :stock_id => 1,
      :open => 1,
      :close => 1,
      :high => 1,
      :low => 1,
      :volume => 1,
      :market_cap => 1
    ))
  end

  it "renders the edit price form" do
    render

    assert_select "form[action=?][method=?]", price_path(@price), "post" do

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

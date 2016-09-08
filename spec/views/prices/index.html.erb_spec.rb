require 'rails_helper'

RSpec.describe "prices/index", type: :view do
  before(:each) do
    assign(:prices, [
      Price.create!(
        :stock_id => 2,
        :open => 3,
        :close => 4,
        :high => 5,
        :low => 6,
        :volume => 7,
        :market_cap => 8,
        :date => 9
      ),
      Price.create!(
        :stock_id => 2,
        :open => 3,
        :close => 4,
        :high => 5,
        :low => 6,
        :volume => 7,
        :market_cap => 8,
        :date => 9
      )
    ])
  end

  it "renders a list of prices" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
#    assert_select "tr>td", :text => 5.to_s, :count => 2
#    assert_select "tr>td", :text => 6.to_s, :count => 2
#    assert_select "tr>td", :text => 7.to_s, :count => 2
#    assert_select "tr>td", :text => 8.to_s, :count => 2
  end
end

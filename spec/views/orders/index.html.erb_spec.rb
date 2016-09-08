require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    assign(:orders, [
      Order.create!(
        :stock_id => 2,
        :buy => 3.5,
        :sell => 4.5,
        :volume => 5
      ),
      Order.create!(
        :stock_id => 2,
        :buy => 3.5,
        :sell => 4.5,
        :volume => 5
      )
    ])
    assign(:stocks, [
      Stock.create!(
        :id => 2,
        :code => 9999,
        :name => "name"
      )
    ])
  end

  it "renders a list of orders" do
    render
    #assert_select "tr>td", :text => 2.to_s, :count => 2
    #assert_select "tr>td", :text => "name".to_s, :count => 2
    #assert_select "tr>td", :text => 3.5.to_s, :count => 2
    #assert_select "tr>td", :text => 4.5.to_s, :count => 2
    #assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end

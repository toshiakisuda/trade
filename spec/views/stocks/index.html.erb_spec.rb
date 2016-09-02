require 'rails_helper'

RSpec.describe "stocks/index", type: :view do
  before(:each) do
    assign(:stocks, [
      Stock.create!(
        :code => "Code",
        :name => "Name"
      ),
      Stock.create!(
        :code => "Code",
        :name => "Name"
      )
    ])
  end

  it "renders a list of stocks" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

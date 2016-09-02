require 'rails_helper'

RSpec.describe "stocks/new", type: :view do
  before(:each) do
    assign(:stock, Stock.new(
      :code => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new stock form" do
    render

    assert_select "form[action=?][method=?]", stocks_path, "post" do

      assert_select "input#stock_code[name=?]", "stock[code]"

      assert_select "input#stock_name[name=?]", "stock[name]"
    end
  end
end

require 'rails_helper'

RSpec.describe "prices/show", type: :view do
  before(:each) do
    @price = assign(:price, Price.create!(
      :stock_id => 2,
      :open => 3,
      :close => 4,
      :high => 5,
      :low => 6,
      :volume => 7,
      :market_cap => 8
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
  end
end

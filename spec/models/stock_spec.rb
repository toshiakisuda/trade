require 'rails_helper'

RSpec.describe Stock, type: :model do
  before(:each) do
      Stock.create!(:id => 1, :code => 9999,:name => "Test1")
      Stock.create!(:id => 2, :code => 8888,:name => "Test2")
      Price.create!(:id => 1, :date => Date.today, :stock_id => 1, :high => 10,:low => 1)
  end

  describe 'Stock method' do
    context '当日のpriceレコードチェック' do
      it "１件もない場合、trueとなること" do
        stock = Stock.where(:id => 2).first
        expect(stock.today_blank?).to eq true
      end

      it "1件以上、存在しない場合、falseとなること" do
        stock = Stock.where(:id => 1).first
        expect(stock.today_blank?).to eq false
      end
    end
  end
end

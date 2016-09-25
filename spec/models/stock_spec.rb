require 'rails_helper'

RSpec.describe Stock, type: :model do
  before(:each) do
      Stock.create(:id => 1, :code => 9999,:name => "Test1")
      Stock.create(:id => 2, :code => 8888,:name => "Test2")
      Price.create(:id => 1, :date => Date.today, :stock_id => 1, :high => 10,:low => 1)
  end

  describe 'Stock method' do
    context '当日のpriceレコードチェック' do
      it "１件もない場合、trueとなること" do
        stock = Stock.find_by(:id => 2)
        expect(stock.today_blank?).to eq true
      end

      it "1件以上、存在しない場合、falseとなること" do
        stock = Stock.where(:id => 1).first
        expect(stock.today_blank?).to eq false
      end

      it "当日のデータがない場合は初回データを登録" do
         stock = Stock.find_by(:id => 2)
         price = { 'high' => 100, 'low' => 10, 'current' => 50}
         stock.timing_order(Time.now,price)

         pstock = stock.prices.find_by(:date => Date.today)
         expect(pstock.high).to eq 100
         expect(pstock.low).to eq 10
         expect(pstock.current).to eq 50 

         price = { 'high' => 100, 'low' => 10, 'current' => 101}
         stock.timing_order(Time.now,price)
         ostock = stock.orders.find_by(:date => Date.today)
         expect(ostock.buy).to eq 101
         expect(ostock.sell).to eq nil

         price = { 'high' => 100, 'low' => 10, 'current' => 110}
         stock.timing_order(Time.now,price)
         ostock = stock.orders.find_by(:date => Date.today)
         expect(ostock.sell).to eq 110
      end
    end
  end
end

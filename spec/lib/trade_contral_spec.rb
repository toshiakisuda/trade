require 'rails_helper'
require 'trade_contral.rb'

describe 'yahoo' do
  before(:each) do
    stock = Stock.create!(:code => 3697, :name => "SHIFT") 
  end

  context 'ファイナンス' do
    it "文字が帰ってくること" do
      trade = TradeContral.new
      trade.process
    end
  end
end

require 'browserContral.rb'

class TradeContral
  def initialize
    @browser = BrowserContral.new    
  end

  def process
    stocks = Stock.all
    stocks.each { |stock|
      price = @browser.get(stock)
      stock.timing_order(Time.now.change(:hour => 9,:min => 30),price)
    } 
  end
end

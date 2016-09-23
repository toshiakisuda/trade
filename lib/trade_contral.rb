require 'browserContral.rb'

class TradeContral
  def initialize
    @browser = BrowserContral.new    
  end

  def process
    stocks = Stock.all
    stocks.each { |stock|
      price = @browser.get(stock)
      @browser.buy if stock.order0930(price)
    } 
  end
end 

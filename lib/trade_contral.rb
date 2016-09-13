require 'browserContral.rb'

class TradeContral
  def initialize
    @browser = BrowserContral.new    
  end

  def process
    stocks = Stock.all
    stocks.each { |stock|
      p @browser.get(stock)
    } 
  end
end 

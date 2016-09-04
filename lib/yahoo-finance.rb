require 'capybara/poltergeist'

class YahooFinanceStock
  def initialize
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
    end
    @session = Capybara::Session.new(:poltergeist)
  end

  def all_get
    stocks = Stock.all
    stocks.map { |stock| 
      @session.visit "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{stock.code}.T"
      Rails.logger.info  @session.status_code
      puts current = @session.find('#stockinf > div.stocksDtl.clearFix > div.forAddPortfolio > table > tbody > tr > td:nth-child(3)').text
      puts high = @session.find('#detail > div.innerDate > div:nth-child(3) > dl > dd > strong').text
      puts low = @session.find('#detail > div.innerDate > div:nth-child(4) > dl > dd > strong').text

      price = [ current , high ,low ].map { |c| c.delete(",") }
      stock.prices.create(:date => Date.today, :current => price[0], :high => price[1], :low => price[2])
    }
  end

  def oder
    @session.visit "https://www.rakuten-sec.co.jp/smartphone/login.html"
    @session.fill_in 'loginid', :with => 'VVJN6362'
    @session.fill_in 'passwd', :with => 'ZQVK0658'
    @session.save_screenshot 'screenshot.png'
    @session.click_button 'ログイン'
    @session.save_screenshot 'screenshot2.png'
  end
end


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
      #当日のデータがあるかどうかを判定
      if stock.prices.exists?(:date => Date.today) 
        #Break outしたらオーダー
        #エントリー金額を追記
        #self.order if price[0].to_f > stock.prices.where(:date => Date.today).first.high 
      else
        stock.prices.create(:date => Date.today, :current.to_f => price[0], :high.to_f => price[1], :low.to_f => price[2])
      end
    }
  end

  def order
    @session.visit "https://www.rakuten-sec.co.jp"
    @session.fill_in 'loginid', :with => 'VVJN6362'
    @session.fill_in 'passwd', :with => 'ZQVK0658'
    @session.save_screenshot 'screenshot.png'
    @session.click_button 'ログイン'
    @session.save_screenshot 'screenshot2.png'
    @session.fill_in 'search-stock-01', :with => '4689'
    @session.click_button 'searchStockFormSearchBtn'
    @session.save_screenshot 'screenshot3.png'
    @session.find("#auto_update_field_info_jp_stock_price > tbody > tr > td:nth-child(1) > form:nth-child(4) > div.lyt-stock-price.clearfix > table:nth-child(1) > tbody > tr > td:nth-child(2) > div > div.box-action.clearfix > table > tbody > tr > td:nth-child(1) > ul.list-spot-trade-jp.roll > li:nth-child(1) > a > img").click

    @session.save_screenshot 'screenshot4.png'
  end
end


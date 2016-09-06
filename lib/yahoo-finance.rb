require 'capybara/poltergeist'

class YahooFinanceStock
  def initialize
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
    end
    @session = Capybara::Session.new(:poltergeist)
    @auth_info = YAML.load(File.open("#{Rails.root}/config/auth.yml"))
    @selector = YAML.load(File.open("#{Rails.root}/config/selector.yml"))
  end

  def all_get
    loop {
      Rails.logger.info  "loop"
      if Time.now > Time.local(2016,9,6,9,30)
        stocks = Stock.all
        stocks.map { |stock| 
          price = get_prices(stock)
          #当日のデータがあるかどうかを判定
          if stock.prices.exists?(:date => Date.today) 
            #Break outしたらオーダー
            #エントリー金額を追記
            Rails.logger.info "entry #{price[0]}" if self.order if price[0].to_f > stock.prices.where(:date => Date.today).first.high 
          else
            stock.prices.create(:date => Date.today, :current => price[0].to_f, :high => price[1].to_f, :low => price[2].to_f)
          end
         }
      else
        Rails.logger.info Time.now.to_s + ":まだ実行しませんよー"
      end
      sleep 10
    }
  end

  def get_prices(stock)
    @session.visit "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{stock.code}.T"
    current = @session.find(@selector['current']).text
    high = @session.find(@selector['high']).text
    low = @session.find(@selector['low']).text
    re = [ current , high ,low ].map { |c| c.delete(",") }
    Rails.logger.info "現在値:" + "#{stock.name}" + "," +"#{stock.code}" +  "," + re[0] + "," + re[1] + "," + re[2]

    return re
  end

  def order
    @session.visit "https://www.rakuten-sec.co.jp"
    @session.fill_in 'loginid', :with => @auth_info['id']
    @session.fill_in 'passwd', :with => @auth_info['pass']
    @session.save_screenshot 'screenshot.png'
    @session.click_button 'ログイン'
    @session.save_screenshot 'screenshot2.png'
    @session.fill_in 'search-stock-01', :with => '4689'
    @session.click_button 'searchStockFormSearchBtn'
    @session.save_screenshot 'screenshot3.png'
    @session.find(selector['buy']).click

    @session.save_screenshot 'screenshot4.png'
  end
end


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
    stocks = Stock.all
    stocks.map { |stock| 
      price = get_prices(stock)
      #当日のデータがあるかどうかを判定
      reference_price(stock, price[0], price[1], price[2])
      #Break outしたらオーダー
      if stock.orders.where(:date => Date.today).blank?
        #if price[0].to_f > stock.prices.today_high
        if price[0].to_f > stock.prices.where(:date => Date.today).first.high
          stock.orders.create(:date => Date.today,:buy => price[0].to_f,:volume => 100)
          Rails.logger.info "entry #{price[0]}"
          self.order stock.code, price[0]
        end
      else
        if stock.orders.where(:date => Date.today).where(:sell => nil)
          #購入金額より1%以上高くなったら売り
          #if stock.orders.today * 1.01 > price[0]
          p kitai = stock.orders.where(:date => Date.today).first.buy * 1.01
          if price[0].to_f > kitai
            Rails.logger.info "sell #{price[0]}"
            stock.orders.where(:date => Date.today).first.update(:sell => price[0])
          else
            #前場が終わったら売り
            stock.orders.where(:date => Date.today).first.update(:sell => price[0]) if Time.now > Time.parse(Date.today.to_s + " 11:30")
            #stock.orders.where(:date => Date.today).first.update(:sell => price[0])
          end
        end
      end
    }
  end

  def reference_price(stock,current,high,low)
    stock.prices.create(:date => Date.today, 
                        :current => current, 
                        :high => high.to_f, 
                        :low => low.to_f) if stock.prices.exists?(:date => Date.today)
  end

  def breakout?

  end

  def market_time?
    if Time.now > Time.parse(Date.today.to_s + " 09:30") && Time.now < Time.parse(Date.today.to_s + " 11:30") 
      Rails.logger.info "Market Time!"
      true
    else
      Rails.logger.info "close the Market!"
      false
    end
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

  def order(code,price)
    @session.visit "https://www.rakuten-sec.co.jp"
    @session.fill_in 'loginid', :with => @auth_info['id']
    @session.fill_in 'passwd', :with => @auth_info['pass']
    @session.save_screenshot 'screenshot.png'
    @session.click_button 'ログイン'
    @session.save_screenshot 'screenshot2.png'
    @session.fill_in 'search-stock-01', :with => code
    @session.click_button 'searchStockFormSearchBtn'
    @session.save_screenshot 'screenshot3.png'
    @session.find(@selector['buy']).click
    @session.fill_in 'orderValue', :with => '100'
    @session.fill_in 'marketOrderPrice', :with => price
    @session.check 'ormit_checkbox'
    @session.fill_in 'password', :with => @auth_info['password'] 
    @session.save_screenshot 'screenshot4.png'
    @session.click_on 'ormit_sbm'

    @session.save_screenshot 'screenshot5.png'
  end
end


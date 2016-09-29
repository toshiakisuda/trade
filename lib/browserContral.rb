require 'capybara/poltergeist'

class BrowserContral 
  def initialize
    @MAX_RETRY = 3
    @selector = YAML.load(File.open("#{Rails.root}/config/selector.yml"))
    @auth_info = YAML.load(File.open("#{Rails.root}/config/auth.yml"))
    Capybara.register_driver :poltergeist do |app|
      if @auth_info['proxy'] 
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, 
                                          :timeout => 10,
                                          :phantomjs_options => ["--proxy=#{@auth_info['proxy']}"] }
                                         )
      else
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 10})
      end
    end
    
    @session = Capybara::Session.new(:poltergeist)
  end

  def get(stock)
    cnt_retry = 0
    begin
      @session.visit "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{stock.code}.T"
      prices = {
                 "current" => @session.find(@selector['current']).text.delete(","),
                 "high" => @session.find(@selector['high']).text.delete(","),
                 "low" => @session.find(@selector['low']).text.delete(",")
               } 
      Rails.logger.info "現在値:#{stock.name},#{stock.code},#{prices['current']},#{prices['high']},#{prices['low']}"
      prices 
    rescue => e
      cnt_retry += 1
      Rails.logger.error "#{e.class},#{e.message},retry=#{cnt_retry}"
      screenshot
      if cnt_retry < @MAX_RETRY
        sleep 1
        retry
      end
      @cnt_retry = 0
    end
  end

  def login
    begin
      @session.visit "https://www.rakuten-sec.co.jp"
      @session.fill_in 'loginid', :with => @auth_info['id']
      @session.fill_in 'passwd', :with => @auth_info['pass']
      @session.click_button 'ログイン'
    rescue => e
      Rails.logger.error "#{e.class},#{e.message}"
      screenshot
    end
  end

  def buy(stock,price,volume)
    login
    begin
      @session.fill_in 'search-stock-01', :with => stock.code
      @session.click_button 'searchStockFormSearchBtn'
      @session.find(@selector['buy']).click
      @session.fill_in 'orderValue', :with => volume 
      @session.fill_in 'marketOrderPrice', :with => price
      @session.check 'ormit_checkbox'
      @session.fill_in 'password', :with => @auth_info['password']
      @session.click_on 'ormit_sbm'
    rescue => e
      Rails.logger.error "#{e.class},#{e.message}"
      screenshot
    end
  end

  def sell
  end

  def get_nikkei_futures
   cnt_retry = 0
   begin
     #マネックス
   rescue => e
     cnt_retry += 1
     Rails.logger.error "#{e.class},#{e.message},retry=#{cnt_retry}"
     screenshot
     if cnt_retry < @MAX_RETRY
       sleep 1
       retry
     end
   end
  end

  def screenshot
    str = Time.now.strftime("%Y%m%d%H%M%S")
    @session.save_screenshot("#{Rails.root}/tmp/#{str}.png")
  end
end

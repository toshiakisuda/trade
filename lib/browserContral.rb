require 'capybara/poltergeist'

class browserContral 
  def initialize
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 10 })
    end
    @session = Capybara::Session.new(:poltergeist)
    @auth_info = YAML.load(File.open("#{Rails.root}/config/auth.yml"))
    @selector = YAML.load(File.open("#{Rails.root}/config/selector.yml"))
  end

  def get(stock)
    begin
      @session.visit "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{stock.code}.T"
      prices.store("current",@session.find(@selector['current']).text)
      prices.store("high",@session.find(@selector['high']).text)
      prices.store("low",@session.find(@selector['low']).text)
      prices.map { |key,val| [key,val.delete(",")] }.to_h
      Rails.logger.info "現在値:#{stock.name},#{stock.code},#{prices['current']},#{prices['high']},#{prices['low']}"
      prices 
    resucue => e
      Rails.logger.error "#{e.class},#{e.messages}"
      screenshot
    end
  end

  def login
    begin
      @session.visit "https://www.rakuten-sec.co.jp"
      @session.fill_in 'loginid', :with => @auth_info['id']
      @session.fill_in 'passwd', :with => @auth_info['pass']
      @session.click_button 'ログイン'
    rescue => e
      Rails.logger.error "#{e.class},#{e.messages}"
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
      Rails.logger.error "#{e.class},#{e.messages}"
      screenshot
    end
  end

  def sell
  end

  def screenshot
    str = Time.now.strftime("%Y%m%d%H%M%S")
    @session.save_screenshot("#{Rails.root}/tmp/#{str}.png")
  end
end

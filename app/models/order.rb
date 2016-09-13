class Order < ActiveRecord::Base
  belongs_to :stock

  def today
    self.find_by(:date => Date.today)
  end

  def today_blank?
    self.where(:date => Date.today).blank?
  end

  def stock_name
    stock = Stock.find_by(:id => self.stock_id)
    stock.name
  end

  def stock_code
    stock = Stock.find_by(:id => self.stock_id)
    stock.code
  end

  def result_trade
    self.sell.present? ? (self.sell - self.buy) * self.volume : 0
  end
end

class Order < ActiveRecord::Base
  belongs_to :stock

  def today
    self.where(:date => Date.today).first
  end

  def today_blank?
    self.where(:date => Date.today).blank?
  end

  def stock_name
    Stock.where(:id => self.stock_id).first.name
  end

  def stock_code
    Stock.where(:id => self.stock_id).first.code
  end

  def result_trade
    self.sell.present? ? (self.sell - self.buy) * self.volume : 0
  end
end

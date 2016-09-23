class Stock < ActiveRecord::Base
  has_many :prices, dependent: :destroy
  has_many :orders, dependent: :destroy

  def today_blank?
    self.prices.where(:date => Date.today).blank?
  end
end

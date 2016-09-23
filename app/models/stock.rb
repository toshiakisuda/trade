class Stock < ActiveRecord::Base
  has_many :prices, dependent: :destroy
  has_many :orders, dependent: :destroy

  def today_blank?
    self.prices.where(:date => Date.today).blank?
  end

  def today_high_price
    stock = self.prices.find_by(:date => Date.today)
    stock.high
  end

  def order0930(price)
    self.prices.create(:date => Date.today, :high => price['high'], 
                       :low => price['low'], :current => price['current']) if self.today_blank?

    if price['current'] > self.today_high_price
      if self.orders.where(:date => Date.today).exists?
        if price['current'] > self.orders.find_by(:date => Date.today).buy * 1.01
          self.orders.find_by(:date => Date.today).update(:sell => price['current'],:volume => 100) 
        end
      else
        self.orders.create(:date => Date.today, :buy => price['current'], :volume => 100) 
      end
    end
  end
end

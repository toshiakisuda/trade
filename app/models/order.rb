class Order < ActiveRecord::Base
  belongs_to :stock

  def today
    self.where(:date => Date.today).first
  end

  def today_blank?
    self.where(:date => Date.today).blank?
  end
end

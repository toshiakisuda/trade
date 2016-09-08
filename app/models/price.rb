class Price < ActiveRecord::Base
  belongs_to :stock

  def today_blank?
    self.where(:date => Date.today).blank?
  end

  def today_high?
    self.where(:date => Date.today).first.high
  end
end

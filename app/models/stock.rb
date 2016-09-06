class Stock < ActiveRecord::Base
  has_many :prices, dependent: :destroy
  has_many :orders, dependent: :destroy
end

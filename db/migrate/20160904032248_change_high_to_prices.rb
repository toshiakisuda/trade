class ChangeHighToPrices < ActiveRecord::Migration
  def change
    change_column :Prices, :high, :float, null: true
    change_column :Prices, :low, :float, null: true
  end
end

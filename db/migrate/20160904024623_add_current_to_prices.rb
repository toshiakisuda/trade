class AddCurrentToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :current, :float
  end
end

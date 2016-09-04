class AddTimeToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :time, :Time
  end
end

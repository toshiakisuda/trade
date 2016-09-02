class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :stock_id
      t.date :date
      t.integer :open
      t.integer :close
      t.integer :high
      t.integer :low
      t.integer :volume
      t.integer :market_cap

      t.timestamps null: false
    end
  end
end

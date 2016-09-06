class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :stock_id
      t.date :date
      t.float :buy
      t.float :sell
      t.integer :volume

      t.timestamps null: false
    end
  end
end

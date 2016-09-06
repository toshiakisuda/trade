json.extract! order, :id, :stock_id, :date, :buy, :sell, :volume, :created_at, :updated_at
json.url order_url(order, format: :json)
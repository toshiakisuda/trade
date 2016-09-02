json.extract! price, :id, :stock_id, :date, :open, :close, :high, :low, :volume, :market_cap, :created_at, :updated_at
json.url price_url(price, format: :json)
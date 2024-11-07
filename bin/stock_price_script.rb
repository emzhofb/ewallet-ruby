# bin/stock_price_script.rb

require_relative '../lib/latest_stock_price'  # Ensure you adjust the path based on your structure

api_key = "327af5fab9msh41703107596c37ap1a1264jsn54d444f8aed4"
client = LatestStockPrice::Client.new(api_key)

# Get the price for a single stock
puts client.price("AAPL")

# Get prices for multiple stocks
puts client.prices(["AAPL", "GOOGL", "MSFT"])

# Get prices for all stocks
puts client.price_all

# Fetch the equities
puts client.equities  # Should return a list of all equities

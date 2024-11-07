require 'net/http'
require 'json'
require 'uri'

module LatestStockPrice
  class Client
    BASE_URL = 'https://latest-stock-price.p.rapidapi.com'

    def initialize(api_key)
      @api_key = api_key
    end

    # Get the price for a single stock
    def price(symbol)
      request("/equities/price", { Symbol: symbol })
    end

    # Get prices for multiple stocks
    def prices(symbols)
      request("/equities/prices", { Symbols: symbols.join(',') })
    end

    # Get prices for all stocks
    def price_all
      request("/equities/price_all")
    end
    
    # New method to get all equities
    def equities
      request("/equities")
    end

    private

    # Internal request handler
    def request(endpoint, params = {})
      uri = URI(BASE_URL + endpoint)
      uri.query = URI.encode_www_form(params) unless params.empty?

      # Initialize HTTP request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'null'
      request['x-rapidapi-ua'] = 'RapidAPI-Playground'
      request['X-RapidAPI-Key'] = @api_key
      request['X-RapidAPI-Host'] = 'latest-stock-price.p.rapidapi.com'

      # Log request details for debugging
      puts "Request URL: #{uri}"
      puts "Headers: #{request.to_hash}"

      response = http.request(request)

      # Handle response
      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        { error: response.message, status: response.code }
      end
    end
  end
end

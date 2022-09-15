require "uri"
require "net/http"

class MapSearchService
  MAX_RADIUS = 1000

  def initialize(location, radius = 200)
    @latitude = location['latitude']
    @longitude = location['longitude']
    @radius = radius
  end

  def call
    search_cycle
  rescue StandardError
    false
  end

  private

  def search_cycle
    while @radius < MAX_RADIUS
      result = make_request
      search_result = json_result(result)
      break if search_result['status'] != "ZERO_RESULTS"
      @radius *= 2
      search_result = false
    end

    search_result
  end

  def url
    URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@latitude}%2C#{@longitude}&radius=#{@radius}&type=restaurant&key=#{Rails.application.credentials[Rails.env.to_sym][:gmaps][:apikey]}")
  end

  def make_request
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    result = https.request(request).read_body
  end

  def json_result(request_result)
    JSON.parse(request_result)
  end
end

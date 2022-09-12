require "uri"
require "net/http"

class MapSearchService
  def initialize(location, radius = 200)
    @latitude = location['latitude']
    @longitude = location['longitude']
    @radius = radius
    @result = {}
  end

  def call
    make_request
    json_result
  end

  private

  def url
    URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@latitude}%2C#{@longitude}&radius=#{@radius}&type=restaurant&key=#{Rails.application.credentials[Rails.env.to_sym][:gmaps][:apikey]}")
  end

  def make_request
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    @response = https.request(request).read_body
  end

  def json_result
    @result.merge(JSON.parse(@response))
  end
end

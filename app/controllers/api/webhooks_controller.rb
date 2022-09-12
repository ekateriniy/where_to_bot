class Api::WebhooksController < Telegram::Bot::UpdatesController
  def start!(*)
    respond_with :message, text: t('telegram.hello')
  end

  def message(*)
    if payload['location']
      @response = MapSearchService.new(payload['location']).call
      respond_with :message, text: response_message
    else
      respond_with :message, text: t('telegram.not_a_location')
    end
  end

  private

  def response_message
    # select first 5 places, since they are already sorted in gmaps by prominence
    result = ""
    @response['results'][0..4].each_with_index do |res, i|
      result << "#{i + 1}.  #{res['name']}, rating: #{res['rating']} (#{res['user_ratings_total']} reviews)\n" if res['rating'] >= 3.5
    end

    "Result:\n#{result}"
  end
end

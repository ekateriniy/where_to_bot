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
    return t('telegram.http_error') unless @response
    
    result_string = ""
    result.each_with_index do |res, i|
      result_string << "#{i + 1}. #{res['name']}, rating: #{res['rating']} (#{res['user_ratings_total']} reviews)\n"
    end

    "Result:\n#{result_string}"
  end

  def result
    # select first 5 places, since they are already sorted in gmaps by prominence
    result = []
    @response['results'].each do |res|
      result << res if res['rating'] >= 3.5 && res['user_ratings_total'] > 500

      break if result.size >= 5
    end

    result
  end
end

require 'redis'
require 'json'

def load_searchterm_data(areas)
  @loaded_search_terms = {}
  areas.each do |area|
    @loaded_search_terms[area] = []
    unless $redis
      redis_uri = URI.parse(ENV["REDISTOGO_URL"])
      $redis = Redis.new(:host => redis_uri.host,
                                :port => redis_uri.port,
                                :password => redis_uri.password)
    end
    search_terms = $redis.hget("dashing-history", "search_terms_#{area}")
    if search_terms
      @loaded_search_terms[area] = JSON.parse(search_terms[6...-1])["items"]
    end
  end
end

def send_delta_event(id, body, area)
  body[:id] = id
  body[:updatedAt] ||= Time.now.to_i
  body[:title] = "What people are searching for"
  send_event(id, body)
  body[:items] = []
  Sinatra::Application.settings.history[id] = format_event(body.to_json)
end

areas = ENV["AREA_NAMES"].split(",")

load_searchterm_data(areas)

SCHEDULER.every '2s' do
  areas.each do |area|
    new_item = { value: @loaded_search_terms[area].sample }
    send_delta_event("search_ticker_#{area}", { item: new_item }, area)
  end
end

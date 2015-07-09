def load_searchterm_data(areas)
  @loaded_search_terms = {}
  @search_terms = {}
  areas.each do |area|
    @loaded_search_terms[area] = []
    history = settings.history['dashing-history']
    if history && history["search_terms_#{area}"]
      @loaded_search_terms[area] = YAML.load(history["search_terms_#{area}"])["data"]["items"]
    end
    @search_terms[area] = []
  end
end

def send_delta_event(id, body, area)
  body[:id] = id
  body[:updatedAt] ||= Time.now.to_i
  body[:title] = "What people are searching for"
  send_event(id, body)
  body[:items] = @search_terms[area]
  Sinatra::Application.settings.history[id] = format_event(body.to_json)
end

areas = ENV["AREA_NAMES"].split(",")

load_searchterm_data(areas)

SCHEDULER.every '2s' do
  areas.each do |area|
    new_item = { value: @loaded_search_terms[area].sample }
    send_delta_event("search_ticker_#{area}", { item: new_item }, area)
    @search_terms[area].unshift new_item
  end
end

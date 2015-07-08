def load_searchterm_data
  @loaded_search_terms = []
  @has_data = false
  if File.exist?(settings.history_file)
    history = YAML.load_file(settings.history_file)
    if history["search_terms"]
      @loaded_search_terms = YAML.load(history["search_terms"])["data"]["items"]
      @has_data = true
    end
  end
  @search_terms = []
end

def send_delta_event(id, body)
  body[:id] = id
  body[:updatedAt] ||= Time.now.to_i
  body[:title] = "What people are searching for"
  send_event(id, body)
  body[:items] = @search_terms
  Sinatra::Application.settings.history[id] = format_event(body.to_json)
end

load_searchterm_data

SCHEDULER.every '2s' do
  new_item = { value: @loaded_search_terms.sample }
  send_delta_event('search_ticker', { item: new_item })
  @search_terms.unshift new_item
end

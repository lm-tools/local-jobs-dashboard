include DashboardHelper
include DashboardItemFormatter

@stored_search_terms = get_search_term_data
@first_time_terms = get_first_time_search_terms(@stored_search_terms)

SCHEDULER.every '2s' do
  areas.each do |area|
    new_item = { value: @stored_search_terms[area].sample }
    send_delta_event("search_ticker_#{area}", { item: new_item, first_items: @first_time_terms[area] }, "People are searching for")
  end
end

include DashboardHelper
include DashboardItemFormatter

SCHEDULER.every '10m', :first_in => 0 do
  areas.each do |area|
    category_hashes = api_client.get_categories(area)
    categories = category_hashes.map do |category_hash|
      format_category(category_hash)
    end
    send_event("categories_#{area}", { title: "Job types with most adverts", items: categories[0..4] })
  end
end

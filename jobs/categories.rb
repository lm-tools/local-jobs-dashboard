require 'json'
require 'date'

SCHEDULER.every '10m', :first_in => 0 do
  ENV["AREA_NAMES"].split(",").each do |area|
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/top_categories?job_centre_label=#{area}"))
    category_hashes = JSON.parse(response.body)
    categories = category_hashes.map do |category_hash|
      {
        "label" => category_hash["category"].sub(/Jobs$/, '')
      }
    end
    send_event("categories_#{area}", { title: "Top Categories", items: categories[0..4] })
  end
end

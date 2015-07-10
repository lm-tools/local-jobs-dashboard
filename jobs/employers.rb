require 'json'
require 'date'

SCHEDULER.every '10m', :first_in => 0 do
  ENV["AREA_NAMES"].split(",").each do |area|
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/top_companies?job_centre_label=#{area}"))
    company_hashes = JSON.parse(response.body)
    companies = company_hashes.map do |company_hash|
      {
        "label" => company_hash["company_name"]
      }
    end
    send_event("employers_#{area}", { title: "Top Employers", items: companies[0..4] })
  end
end

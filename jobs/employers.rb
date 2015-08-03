include DashboardHelper
include DashboardItemFormatter

SCHEDULER.every '10m', :first_in => 0 do
  areas.each do |area|
    company_hashes = api_client.get_companies(area)
    companies = company_hashes.map do |company_hash|
      format_company(company_hash)
    end
    send_event("employers_#{area}", { title: "Employers with most adverts", items: companies[0..4] })
  end
end

require 'json'
require 'date'

SCHEDULER.every '10m', :first_in => 0 do
  ENV["AREA_NAMES"].split(",").each do |area|
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/jobadverts/?job_centre_label=#{area}&limit=10"))
    job_hashes = JSON.parse(response.body)["results"]
    jobs = job_hashes.map do |job_hash|
      display_labels = {
        "full_time" => "Full Time",
        "part_time" => "Part Time"
      }
      travel_time = TravelTimeFormatter.new(job_hash["travelling_time"].to_i).run
      result = {
        job_title: job_hash["title"],
        company: job_hash["company_name"],
        created: "Posted "+TimeHumanizer.new(DateTime.now, DateTime.parse(job_hash["created"])).run,
        category: job_hash["category"].sub(/Jobs$/, ''),
        contract_time: display_labels.fetch(job_hash["contract_time"], job_hash["contract_time"])
      }
      if travel_time
        result[:travelling_time] = "Approximately #{travel_time} away"
      end
      result
    end
    send_event("jobs_#{area}", { title: "Latest jobs", items: jobs })
  end
end

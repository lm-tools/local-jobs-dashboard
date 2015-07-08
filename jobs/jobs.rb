require 'json'
require 'date'

SCHEDULER.every '10m', :first_in => 0 do
  response = Net::HTTP.get_response(URI('https://lm-tools-jobs-api.herokuapp.com/api/jobs_in_area/?format=json'))
  job_hashes = JSON.parse(response.body)
  jobs = job_hashes.map do |job_hash|
    
    display_labels = {
      "full_time" => "Full Time",
      "part_time" => "Part Time"
    }

    {
      job_title: job_hash["job_title"],
      company: job_hash["company"]["display_name"],
      created: Time.parse(job_hash["created"]).ago_in_words,
      category: job_hash["job_category"],
      contract_time: display_labels.fetch(job_hash["contract_time"], job_hash["contract_time"])
    }
  end
  send_event('jobs', { title: "Latest jobs", items: jobs })
end

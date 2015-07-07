require 'json'
require 'date'

SCHEDULER.every '10m' do
  response = Net::HTTP.get_response(URI('https://lm-tools-jobs-api.herokuapp.com/api/jobs_in_area/?format=json'))
  job_hashes = JSON.parse(response.body)
  jobs = job_hashes.map do |job_hash|
    {
      job_title: job_hash["job_title"],
      company: job_hash["company"]["display_name"],
      created: DateTime.parse(job_hash["created"]).strftime("%e %b %Y %H:%M:%S%p"),
      category: job_hash["job_category"]
    }
  end
  send_event('jobs', { title: "Latest jobs", items: jobs })
end

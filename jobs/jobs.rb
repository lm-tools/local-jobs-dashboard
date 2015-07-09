require 'json'
require 'date'

SCHEDULER.every '10m', :first_in => 0 do
  ENV["AREA_NAMES"].split(",").each do |area|
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/jobadverts/?job_centre_label=#{area}"))
    job_hashes = JSON.parse(response.body)
    jobs = job_hashes.map do |job_hash|
      display_labels = {
        "full_time" => "Full Time",
        "part_time" => "Part Time"
      }
      {
        job_title: job_hash["title"],
        company: job_hash["company_name"],
        created: minutes_in_words(job_hash["created"]),
        category: job_hash["category"].sub(/Jobs$/, ''),
        contract_time: display_labels.fetch(job_hash["contract_time"], job_hash["contract_time"])
      }
    end
    send_event("jobs_#{area}", { title: "Latest jobs", items: jobs })
  end
end


# Grabbed from http://snippets.aktagon.com/snippets/225-time-ago-in-words-minutes-hours-days-weeks-months-ago-in-words-
def minutes_in_words(time_str)
    minutes = (((Time.now - Time.parse(time_str)).abs)/60).round

    return nil if minutes < 0

    case minutes
      when 0..4            then '5 minutes ago'
      when 5..14           then '15 minutes ago'
      when 15..29          then '30 minutes ago'
      when 30..59          then '30 minutes ago'
      when 60..119         then '1 hour ago'
      when 120..239        then '2 hours ago'
      when 240..479        then '4 hours ago'
      when 480..719        then '8 hours ago'
      when 720..1439       then '12 hours ago'
      when 1440..11519     then '' << pluralize((minutes/1440).floor, 'day')
      when 11520..43199    then '' << pluralize((minutes/11520).floor, 'week')
      when 43200..525599   then '' << pluralize((minutes/43200).floor, 'month')
      else                      '' << pluralize((minutes/525600).floor, 'year')
    end
  end

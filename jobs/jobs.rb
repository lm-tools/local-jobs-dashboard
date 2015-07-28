include DashboardHelper
include DashboardItemFormatter

@jobs = {}
@job_ticker_indexes = {}
@first_time_jobs = {}
areas.each do |area|
  job_hashes = api_client.get_jobs(area)
  @jobs[area] = job_hashes.map do |job_hash|
    format_job(job_hash)
  end
  @first_time_jobs[area] = @jobs[area][0..4]
  @job_ticker_indexes[area] = 5
end

# Stores fresh data in @jobs

SCHEDULER.every '10m', :first_in => 0 do
  areas.each do |area|
    job_hashes = api_client.get_jobs(area)
    @jobs[area] = job_hashes.map do |job|
      format_job(job)
    end
    @job_ticker_indexes[area] = 0
  end
end

SCHEDULER.every '4s', :first_in => 0 do
  areas.each do |area|
    unless @jobs[area].empty?
      new_item = @jobs[area][@job_ticker_indexes[area] % @jobs[area].count]
      @job_ticker_indexes[area] += 1
      send_delta_event("jobs_#{area}", { item: new_item, first_items: @first_time_jobs[area] }, "Latest jobs online")
    end
  end
end

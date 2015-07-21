class LocalJobsApiClient

  def get_jobs(area)
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/jobadverts/?job_centre_label=#{area}&limit=100"))
    JSON.parse(response.body)
  end

  def get_categories(area)
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/top_categories?job_centre_label=#{area}"))
    JSON.parse(response.body)
  end

  def get_companies(area)
    response = Net::HTTP.get_response(URI("#{ENV["JOBS_API_URL"]}/api/top_companies?job_centre_label=#{area}"))
    JSON.parse(response.body)
  end

end

require 'redis'

module DashboardHelper
  def areas
    ENV["AREA_NAMES"].split(",")
  end

  def api_client
    LocalJobsApiClient.new
  end

  def send_delta_event(id, body, title)
    body[:id] = id
    body[:updatedAt] ||= Time.now.to_i
    body[:title] = title
    send_event(id, body)
  end

  def load_redis_if_not_loaded
    unless $redis
      redis_uri = URI.parse(ENV["REDISTOGO_URL"])
      $redis = Redis.new(:host => redis_uri.host,
                         :port => redis_uri.port,
                         :password => redis_uri.password)
    end
  end

  def get_search_term_data
    result = {}
    areas.each do |area|
      result[area] = []
      load_redis_if_not_loaded
      search_terms = $redis.hget("dashing-history", "search_terms_#{area}")
      if search_terms
        result[area] = JSON.parse(search_terms[6...-1])["items"]
      end
    end
    result
  end

  def get_first_time_search_terms(stored_search_terms)
    result = {}
    areas.each do |area|
      result[area] = stored_search_terms[area].sample(50).map do |search_term|
        { value: search_term }
      end
    end
    result
  end

end

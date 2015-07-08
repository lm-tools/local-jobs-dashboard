require 'dashing'
require 'redis-objects'

redis_uri = URI.parse(ENV["REDISTOGO_URL"])
Redis.current = Redis.new(:host => redis_uri.host,
                          :port => redis_uri.port,
                          :password => redis_uri.password)

set :history, Redis::HashKey.new('dashing-history', :marshal => true)

configure do
  set :auth_token, ENV['AUTH_TOKEN']

  helpers do

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      username = ENV['HTTP_USERNAME']
      password = ENV['HTTP_PASSWORD']
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [username, password]
    end

  end

end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application

require 'csv'
require 'uri'
require 'cgi'
require 'net/http'
require 'json'

# Add your CSV data file inside the scripts/data folder
# Set the following environment variables (see README for more details)

auth_token = ENV["AUTH_TOKEN"]
file_name = ENV["FILE_NAME"]
dashboard_url = ENV["DASHBOARD_URL"]
widget_id = ENV["WIDGET_ID"]

# Parse CSV and collect the query strings

results = []
searches = CSV.read('./scripts/data/'+file_name)
searches[1...searches.length].each do |search|
  search_url = search[0]
  if search_url
    uri = URI.parse(URI::encode(search_url))
    query_params = CGI.parse(uri.query)
    unless query_params["q"].empty?
      results += query_params["q"]
    end
    unless query_params["qor"].empty?
      results += query_params["qor"]
    end
  end
end

# Clean the query strings

cleaned_results = results.grep(/./).map(&:downcase).map(&:strip).map do |search_string|
  search_string.gsub(" \\", "")
end.select { |search_string| search_string.length < 50 }

# POST to dashboard

json_headers = {"Content-Type" => "application/json",
                "Accept" => "application/json"}
params = {'auth_token' => auth_token, 'items' => cleaned_results}
uri = URI.parse(dashboard_url+'/widgets/'+widget_id)
http = Net::HTTP.new(uri.host, uri.port)
response = http.post(uri.path, params.to_json, json_headers)

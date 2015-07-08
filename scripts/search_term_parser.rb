require 'csv'
require 'uri'
require 'cgi'
require 'net/http'
require 'json'

# Add your CSV data file inside the scripts/data folder
# Change the values to the four following entries to something sensible
auth_token = 'insert-the-auth-token-here'
file_name = 'the-name-of-your-csv-file.csv'
dashboard_url = 'http://your-dashboard-url.com'
widget_id = 'your-searches-widget-id'

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
dashing_formatted_results = cleaned_results.map do |cleaned_result|
  { "value" => cleaned_result }
end
params = {'auth_token' => auth_token, 'items' => dashing_formatted_results}
uri = URI.parse(dashboard_url+'/widgets/'+widget_id)
http = Net::HTTP.new(uri.host, uri.port)
response = http.post(uri.path, params.to_json, json_headers)

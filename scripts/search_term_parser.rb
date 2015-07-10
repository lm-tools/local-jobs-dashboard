require 'csv'
require 'uri'
require 'cgi'
require 'net/http'
require 'json'

# Add your CSV data file inside the scripts/data folder
# Set the following environment variables (see README for more details)

auth_token = ENV["AUTH_TOKEN"]
area_names = ENV["AREA_NAMES"].split(",")
file_names = ENV["FILE_NAMES"].split(",")
dashboard_url = ENV["DASHBOARD_URL"]
searches_widget_id = ENV["SEARCHES_WIDGET_ID"]
top_terms_widget_id = ENV["TOP_TERMS_WIDGET_ID"]
top_terms_count = 5

area_files = Hash[area_names.zip(file_names)]

area_files.each { |area_name, file_name|
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
  
  
  # Count term frequency 
  grouped_terms = Hash.new(0)
  cleaned_results.each do |term|
    grouped_terms[term] += 1
  end
  top_5_terms =  grouped_terms.sort_by {|_key, value| value}.reverse[0..top_terms_count-1].map do | term |
    {label: term[0], value: term[1]}
  end

  json_headers = {"Content-Type" => "application/json",
                  "Accept" => "application/json"}

  # POST terms to dashboard
  params = {'auth_token' => auth_token, 'items' => cleaned_results}
  uri = URI.parse(dashboard_url+'/widgets/'+searches_widget_id+'_'+area_name)
  http = Net::HTTP.new(uri.host, uri.port)
  response = http.post(uri.path, params.to_json, json_headers)

  # POST top searches to dashboard
  params = {'auth_token' => auth_token, 'items' => top_5_terms}
  uri = URI.parse(dashboard_url+'/widgets/'+top_terms_widget_id+'_'+area_name)
  http = Net::HTTP.new(uri.host, uri.port)
  response = http.post(uri.path, params.to_json, json_headers)
}

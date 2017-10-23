require 'csv'
require 'json'
require 'cgi'
require 'net/http'
require 'namae'

BASE_URL = 'https://pub.sandbox.orcid.org/v2.0/search/'
TOKEN = '' # your token here

$org_name = 'cincinnati'
$csv_file = 'names.csv'

$results = Array.new

def parse_name(input_name)
  names = Namae.parse input_name
  names[0]
end

def search_url(name)
  "#{BASE_URL}?q=given-names:#{CGI::escape(name.given)}"\
  "~+AND+family-name:#{name.family}&fq=affiliation-org-name:#{$org_name}"
end

def query_api(name)
  url = URI.parse(BASE_URL)
  req = Net::HTTP::Get.new(search_url(name),
          initheader = {
            'Authorization type' => 'Bearer',
            'Content-Type' => 'application/json',
            'Access token' => TOKEN
          })
  res = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
    http.request(req)
  end
  res.body
end

def parse_csv
  CSV.foreach($csv_file, col_sep: ';').each do |row|
    puts "Checking name... #{row[0]}"
    response = JSON.parse(query_api(parse_name(row[0])))
    if response['result'].empty?
      $results << "#{row[0]}, --"
    else
      response['result'].each do |value|
        $results << "#{row[0]}, #{value['orcid-identifier']['uri']}"
      end
    end
  end
end

def write_results
  File.open('results.csv', 'w') do |file|
    file.syswrite $results.join "\n"
  end
end

parse_csv
write_results

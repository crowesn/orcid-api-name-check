# let's pull some names from the orcid API
require 'csv'
require 'roo'
require 'net/http'
require 'namae'

BASE_URL = 'https://pub.sandbox.orcid.org/v2.0/search/'
TOKEN = '' # your token here

  org_name = 'cincinnati'
  input_name = 'Crowe, Sean'

def name(input_name)
  names = Namae.parse input_name
  names[0]
end

def search_url(name, org_name)
  "https://pub.sandbox.orcid.org/v2.0/search/?q=given-names:#{CGI::escape(name.given)}~+AND+family-name:#{name.family}&fq=affiliation-org-name:#{org_name}"
end

def query_api(name, org_name)
  url = URI.parse(BASE_URL)
  req = Net::HTTP::Get.new(search_url(name, org_name), initheader = {'Authorization type' => 'Bearer', 'Content-Type' =>'application/json', 'Access token' => TOKEN } )
  res = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
      http.request(req)
  }
  res.body
end

a = query_api( name(input_name), org_name )
puts a

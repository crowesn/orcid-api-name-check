from nameparser import HumanName
from urllib import parse
import requests
import csv
import json

token = '' # Your API Token Here
base_url = 'https://pub.sandbox.orcid.org/v2.0/search/'
org_name = 'cincinnati'
csv_file = 'names.csv'
output_file = 'results.csv'
results = []

def parse_csv():
  with open(csv_file, newline = '') as csvfile:
    name_reader = csv.reader(csvfile, delimiter = ';')
    for row in name_reader:
      print("Checking name... " + row[0])
      query_results = query_api(parse_name(row[0]))['result']
      if query_results:
        for query_result in query_results:
          results.append(f"{row[0]}, {query_result['orcid-identifier']['uri']}\n")
      else:
        results.append(f"{row[0]}, --\n")

def parse_name(input_name):
  name = HumanName(input_name)
  return name

def query_api(name):
  url = (f"{base_url}?q=given-names:{parse.quote_plus(name.first)}~+AND+family-name:"
         f"{parse.quote_plus(name.last)}&fq=affiliation-org-name:{org_name}")

  head = { 'Authorization type':'Bearer',
          'Content-Type':'application/json',
          'Access token':token }

  response = requests.get(url, headers = head)
  return response.json()

def write_csv():
  output = open(output_file, 'w')
  for result in results:
    output.write(result)
  output.close

parse_csv()
write_csv()

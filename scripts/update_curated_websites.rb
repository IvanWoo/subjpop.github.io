# frozen_string_literal: true

require 'csv'
require 'yaml'

ROOT_DIR = File.expand_path('..', __dir__)
SITES_CSV = "#{ROOT_DIR}/_data/_curated_websites.csv"
SITES_YAML = "#{ROOT_DIR}/_data/curated_websites.yml"

def input
  data = CSV.read(SITES_CSV, **{ encoding: 'UTF-8', headers: true })

  # Yaml Cookbook: http://yaml.org/YAML_for_ruby.html
  entries = []
  data.each do |datum|
    entries.push({ 'name' => datum[0], 'url' => datum[1] })
  end
  entries
end

def output(entries)
  File.open(SITES_YAML, 'w') do |f|
    f.write(entries.to_yaml)
  end

  puts '💎 curated websites list generated successfully'
end

def main
  entries = input
  output(entries)
end

main

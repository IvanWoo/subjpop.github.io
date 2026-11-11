# frozen_string_literal: true

require 'csv'
require 'yaml'

ROOT_DIR = File.expand_path('..', __dir__)
SITES_CSV = "#{ROOT_DIR}/_data/_curated_websites.csv".freeze
SITES_YAML = "#{ROOT_DIR}/_data/curated_websites.yml".freeze

def input
  data = CSV.read(SITES_CSV, encoding: 'UTF-8', headers: true)

  # Yaml Cookbook: http://yaml.org/YAML_for_ruby.html
  data.map do |datum|
    { 'name' => datum[0], 'url' => datum[1] }
  end
end

def output(entries)
  File.write(SITES_YAML, entries.to_yaml)

  puts '💎 curated websites list generated successfully'
end

def main
  entries = input
  output(entries)
end

main

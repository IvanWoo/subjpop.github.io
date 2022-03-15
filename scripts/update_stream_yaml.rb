# frozen_string_literal: true

require_relative '../lib/all_stream_tables'

ROOT_DIR = File.expand_path('..', __dir__)
STREAM_YAML = "#{ROOT_DIR}/_data/stream_yaml.yml"

def output(stream_table)
  old_stream_table = YAML.safe_load(File.read(STREAM_YAML))
  old_stream_table = {} if old_stream_table.nil?
  stream_table = old_stream_table.merge(stream_table)
  File.write(STREAM_YAML, stream_table.to_yaml)

  puts '💎 rss feed generated successfully'
end

def main
  output(all_stream_tables)
end

main

# frozen_string_literal: true

require_relative '../lib/podcast_hosts'

ROOT_DIR = File.expand_path('..', __dir__)
STREAM_YAML = "#{ROOT_DIR}/_data/stream_yaml.yml"

def output(stream_table)
  old_stream_table = YAML.safe_load(File.read(STREAM_YAML))
  stream_table = old_stream_table.merge(stream_table)
  File.open(STREAM_YAML, 'w') do |file|
    file.write stream_table.to_yaml
  end

  puts '💎 rss feed generated successfully'
end

def main
  lizhi = Lizhi.new(LIZHI_RADIO_ID)
  ximalaya = Ximalaya.new(XIMALAYA_ALBUM_ID)
  stream_table = ximalaya.stream_table.merge(lizhi.stream_table)
  output(stream_table)
end

main

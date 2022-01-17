# frozen_string_literal: true

require 'concurrent'

require_relative '../lib/podcast_hosts'

ROOT_DIR = File.expand_path('..', __dir__)
STREAM_YAML = "#{ROOT_DIR}/_data/stream_yaml.yml"

def output(stream_table)
  old_stream_table = YAML.safe_load(File.read(STREAM_YAML))
  old_stream_table = {} if old_stream_table.nil?
  stream_table = old_stream_table.merge(stream_table)
  File.open(STREAM_YAML, 'w') do |file|
    file.write stream_table.to_yaml
  end

  puts '💎 rss feed generated successfully'
end

def main_fast
  pool = Concurrent::ThreadPoolExecutor.new(max_threads: 4)
  podcast_hosts = [Lizhi.new, Ximalaya.new]
  stream_tables = podcast_hosts.map do |podcast_host|
    Concurrent::Future.execute({ executor: pool }) do
      podcast_host.stream_table
    end
  end.map(&:value)

  # merge a list of hash into a single hash
  res = stream_tables.reduce(:merge)
  output(res)
end

def main_slow
  lizhi = Lizhi.new
  ximalaya = Ximalaya.new
  stream_table = ximalaya.stream_table.merge(lizhi.stream_table)
  output(stream_table)
end

def main
  main_fast
end

main

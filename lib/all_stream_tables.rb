# frozen_string_literal: true

require 'concurrent'

require_relative './podcast_hosts'

def _all_stream_tables_slow
  lizhi = Lizhi.new
  ximalaya = Ximalaya.new
  ximalaya.stream_table.merge(lizhi.stream_table)
end

def _all_stream_tables_fast
  pool = Concurrent::ThreadPoolExecutor.new(max_threads: 4)
  podcast_hosts = [Lizhi.new, Ximalaya.new]
  stream_tables = podcast_hosts.map do |podcast_host|
    Concurrent::Future.execute({ executor: pool }) do
      podcast_host.stream_table
    end
  end.map(&:value!)

  # merge a list of hash into a single hash
  stream_tables.reduce(:merge)
end

def all_stream_tables
  _all_stream_tables_fast
end

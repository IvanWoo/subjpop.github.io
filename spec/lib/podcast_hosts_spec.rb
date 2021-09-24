# frozen_string_literal: true

require_relative '../../lib/podcast_hosts'

RSpec.describe 'podcast_hosts' do
  # set `host_url`
  shared_examples 'scrap_success' do
    it 'has stream_table' do
      stream_table = subject.stream_table
      expect(stream_table.keys).to all(match(host_url))
      expect(stream_table.length).to satisfy('be positive') { |v| v.positive? }
    end
  end

  describe Lizhi do
    let(:host_url) { 'www.lizhi.fm' }

    it_behaves_like 'scrap_success'
  end

  describe Ximalaya do
    let(:host_url) { 'www.ximalaya.com/yinyue' }

    it_behaves_like 'scrap_success'
  end
end

# frozen_string_literal: true

require_relative '../../lib/podcast_hosts'

RSpec.describe 'podcast_hosts' do
  # set `host_url`
  shared_examples 'scrap_success' do
    let(:stream_table) { subject.stream_table }

    it 'has stream_table' do
      expect(stream_table.keys).to all(include(host_url))
      expect(stream_table.length).to be_positive
    end

    it 'has valid url' do
      stream_table.each_value do |val|
        expect(val['url']).not_to be_nil
        expect(val['url']).to start_with('http')
      end
    end

    it 'has valid duration' do
      stream_table.each_value do |val|
        expect(val['duration']).to be_positive
      end
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

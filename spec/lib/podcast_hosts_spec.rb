# frozen_string_literal: true

require_relative '../../lib/podcast_hosts'

RSpec.describe Lizhi do
  it 'has stream_table' do
    lizhi = described_class.new(LIZHI_RADIO_ID)
    stream_table = lizhi.stream_table
    expect(stream_table.keys).to all(match('www.lizhi.fm'))
    expect(stream_table.length).to satisfy('be positive') { |v| v.positive? }
  end
end

RSpec.describe Ximalaya do
  it 'has stream_table' do
    ximalaya = described_class.new(XIMALAYA_ALBUM_ID)
    stream_table = ximalaya.stream_table
    expect(stream_table.keys).to all(match('www.ximalaya.com/yinyue'))
    expect(stream_table.length).to satisfy('be positive') { |v| v.positive? }
  end
end

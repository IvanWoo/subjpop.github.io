# frozen_string_literal: true

require_relative '../../lib/all_stream_tables'

RSpec.describe 'all_stream_tables' do
  subject(:stream_table) { all_stream_tables }

  describe all_stream_tables do
    it 'has stream_table' do
      expect(stream_table.length).to be_positive
    end
  end
end

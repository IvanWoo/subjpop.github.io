# frozen_string_literal: true

require 'ruby-prof'

require_relative '../lib/podcast_hosts'

result = RubyProf.profile do
  Ximalaya.new.stream_table
end

printer = RubyProf::GraphHtmlPrinter.new(result)

File.open('out.html', 'w') do |file|
  printer.print(file, min_percent: 1)
end

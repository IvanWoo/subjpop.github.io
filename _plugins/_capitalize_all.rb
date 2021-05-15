# frozen_string_literal: true

require 'liquid'
require 'uri'

# Capitalize all words of the input
module CapitalizeAll
  def capitalize_all(words)
    words.split(' ').map(&:capitalize).join(' ')
  end
end

Liquid::Template.register_filter(CapitalizeAll)

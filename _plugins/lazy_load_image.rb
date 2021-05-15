# frozen_string_literal: true

require 'jekyll-lazy-load-image'

JekyllLazyLoadImage.configure do |config|
  config.owners = :posts
end

JekyllLazyLoadImage.execute

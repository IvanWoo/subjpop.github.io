# frozen_string_literal: true

# https://stackoverflow.com/questions/3668607/how-to-excute-commands-within-rake-tasks
task(:prep) do
  sh('bundle exec ruby scripts/update_stream_yaml.rb')
  sh('bundle exec ruby scripts/update_curated_websites.rb')
end

task(:dev) do
  puts 'prep data'
  sh('rake prep')
  puts 'start serve watch'
  sh('bundle exec jekyll serve --livereload')
  sh('open http://127.0.0.1:4000/')
end

task(:build) do
  puts 'start build'
  sh('bundle exec jekyll build')
end

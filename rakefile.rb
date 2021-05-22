# frozen_string_literal: true

# https://stackoverflow.com/questions/3668607/how-to-excute-commands-within-rake-tasks
task(:prep) do
  sh 'bundle exec ruby scripts/update_stream_yaml.rb'
  sh 'bundle exec ruby scripts/update_curated_websites.rb'
end

task(:dev) do
  sh 'rake prep'
  sh 'bundle exec jekyll serve --livereload'
  sh 'open http://127.0.0.1:4000/'
end

task(:build) do
  sh 'bundle exec jekyll build'
end

# https://www.danielsieger.com/blog/2021/03/28/check-broken-links-jekyll.html
task(:test) do
  sh 'rake build'
  sh 'bundle exec htmlproofer --assume_extension ./_site'
end

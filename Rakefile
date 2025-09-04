# frozen_string_literal: true

# https://stackoverflow.com/questions/3668607/how-to-excute-commands-within-rake-tasks
desc 'Prepare the data'
task :prep do
  # sh 'bundle exec ruby scripts/update_stream_yaml.rb'
  sh 'bundle exec ruby scripts/update_curated_websites.rb'
end

desc 'Start the dev server'
task dev: [:prep] do
  sh 'bundle exec jekyll serve --livereload --host localhost --open-url'
end

desc 'Build the site'
task :build do
  sh 'bundle exec jekyll build'
end

desc 'Clean Jekyll cache'
task :clean do
  sh 'bundle exec jekyll clean'
end

desc 'Rspec test'
task :test do
  sh 'bundle exec rspec'
end

# https://www.danielsieger.com/blog/2021/03/28/check-broken-links-jekyll.html
desc 'Test the broken links'
task test_links: [:build] do
  sh 'bundle exec htmlproofer --assume_extension ./_site'
end

desc 'Rubocop lint'
task :lint do
  sh 'bundle exec rubocop --enable-pending-cops'
end

desc 'Rubocop lint with auto fixing'
task :lint! do
  sh 'bundle exec rubocop --enable-pending-cops -A'
end

desc 'Benchmark the scrapers'
task :benchmark do
  sh '(cd benchmark && bundle exec ruby podcast_hosts.rb)'
end

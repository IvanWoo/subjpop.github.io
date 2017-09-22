task(:dev) do
  puts "start serve watch"
  sh('open http://127.0.0.1:4000/')
  sh('bundle exec jekyll serve --watch --limit_posts 1')
end

task(:build) do
  puts "start building"
  sh('subjpop')
end


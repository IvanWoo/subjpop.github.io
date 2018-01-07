# SUBJPOP

## How-to use

Install the dependencies with [Bundler](http://bundler.io/):

~~~bash
$ bundle install
~~~

Run `jekyll` commands through Bundler to ensure you're using the right versions:

~~~bash
$ bundle exec jekyll serve
~~~

[Before you upload the generated files to the server](https://stackoverflow.com/questions/41511696/jekyll-build-is-putting-localhost-links-in-site-production-files/41512277):

~~~bash
$ bundle exec jekyll build
~~~

## Tips
- [Bundler's Purpose and Rationale](http://bundler.io/rationale.html)
- [Speed up Jekyll site regeneration](http://www.marcusoft.net/2015/11/speed-up-jekyll-site-regeneration.html)
~~~bash
$ bundle exec jekyll serve --watch --limit_posts 3
~~~

## Credit
- The Jekyll theme was modified based on [Treat](https://github.com/CloudCannon/treat-jekyll-template). 
- [The Internet Archive BookReader](https://github.com/internetarchive/bookreader) was developed by [Richard Caceres](https://github.com/rchrd2).
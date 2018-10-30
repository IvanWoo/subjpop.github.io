# SUBJPOP

## How-to use

Install the dependencies with [Bundler](http://bundler.io/):

~~~bash
$ npm install
$ bundle install
~~~

Run `jekyll` commands through Bundler to ensure you're using the right versions:

~~~bash
$ npm run start
$ bundle exec jekyll serve
~~~

[Before you upload the generated files to the server](https://stackoverflow.com/questions/41511696/jekyll-build-is-putting-localhost-links-in-site-production-files/41512277):

~~~bash
$ npm run build
$ bundle exec jekyll build
~~~

## Tips
- [Bundler's Purpose and Rationale](http://bundler.io/rationale.html)
- [Jekyll flags](https://jekyllrb.com/docs/usage/)
- [Speed up Jekyll site regeneration](http://www.marcusoft.net/2015/11/speed-up-jekyll-site-regeneration.html)
~~~bash
$ bundle exec jekyll serve --livereload --limit_posts 1
~~~
- [Automatic refreshing supported by jekyll 3.7.0](https://jekyllrb.com/news/2018/01/02/jekyll-3-7-0-released/)
~~~bash
$ bundle exec jekyll serve --livereload
~~~

## Credit
- The Jekyll theme was customized based on [Treat](https://github.com/CloudCannon/treat-jekyll-template). 
- [The Internet Archive BookReader](https://github.com/internetarchive/bookreader) was developed by [Richard Caceres](https://github.com/rchrd2).
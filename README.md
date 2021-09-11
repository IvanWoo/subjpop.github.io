# SUBJPOP
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

## How-to use

Install the dependencies with [Bundler](http://bundler.io/):

```bash
$ npm install
$ bundle install
```

Run `jekyll` commands through Bundler to ensure you're using the right versions:

```bash
$ npm run start
$ rake dev
```

[Before you upload the generated files to the server](https://stackoverflow.com/questions/41511696/jekyll-build-is-putting-localhost-links-in-site-production-files/41512277):

```bash
$ npm run build
$ rake build
```

Auto format

```bash
$ bundle exec rubocop --enable-pending-cops -a
```

## Tips
- [Bundler's Purpose and Rationale](http://bundler.io/rationale.html)
- [Jekyll flags](https://jekyllrb.com/docs/usage/)
- [Speed up Jekyll site regeneration](http://www.marcusoft.net/2015/11/speed-up-jekyll-site-regeneration.html)
```bash
$ bundle exec jekyll serve --livereload --host localhost --open-url --limit_posts 1 
```
- [Automatic refreshing supported by jekyll 3.7.0](https://jekyllrb.com/news/2018/01/02/jekyll-3-7-0-released/)
```bash
$ bundle exec jekyll serve --livereload --host localhost --open-url
```

## Credit
- The Jekyll theme was customized based on [Treat](https://github.com/CloudCannon/treat-jekyll-template). 
- [The Internet Archive BookReader](https://github.com/internetarchive/bookreader) was developed by [Richard Caceres](https://github.com/rchrd2).
## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://yifanwu.studio/"><img src="https://avatars.githubusercontent.com/u/15613549?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Yifan Wu</b></sub></a><br /><a href="https://github.com/IvanWoo/subjpop.github.io/commits?author=IvanWoo" title="Code">💻</a> <a href="#maintenance-IvanWoo" title="Maintenance">🚧</a> <a href="https://github.com/IvanWoo/subjpop.github.io/commits?author=IvanWoo" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/idmimida"><img src="https://avatars.githubusercontent.com/u/39655292?v=4?s=100" width="100px;" alt=""/><br /><sub><b>mimida</b></sub></a><br /><a href="https://github.com/IvanWoo/subjpop.github.io/commits?author=idmimida" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
# Jekyll Boilerplate

This is intended as a starting point for a Jekyll website. Be sure to update `README.md`, `package.json`, `_config.yml` and any other config files to match your site's title and url.

# [WebsiteTitle.com][websitetitle.com]

> Powered by [Netlify][netlify]

## JAMstack

This site was imported using the [WordPress Markdown Generator](https://github.com/HigherEducation/Frontend/tree/master/Static%20Site%20Generator/WPMarkdown) and is deployed to Netlify through its GitHub repo.

### Initial Setup

After you clone the repo, you can then use `npm` to install Gulp.js to create your first local build:

### Pre-requisites

You will need:

* [npm](https://docs.npmjs.com/getting-started/installing-node)
* [Bundler](http://bundler.io/)
* [gulp](https://gulpjs.com/)

You can then use **npm** to install **gulp**:

1.  Install **gulp** globally: `npm install --global gulp-cli`
    _(If you have previously installed a version of gulp globally, please run `npm rm --global gulp` to make sure your old version doesn't collide with gulp-cli.)_
1.  Install gulp in your project devDependencies: `npm install --save-dev gulp`
1.  Run **npm**: `npm install`
1.  Run **Bundler**: `bundler install`
1.  Follow the instructions here to [create a Self-Signed SSL Certificate](<https://github.com/HigherEducation/Frontend/wiki/BrowserSync(localhost)---Self-Signed-Certificate>)
1.  Create a local build: `gulp build --dev`
1.  Start your local server: `gulp serve`

## Builds

#### Production Build

* Branch: Master
* Config: config.yml
* Jekyll Environment: `production`
* Command: `gulp build`
* Minification: HTML, CSS, JS, etc
* Sourcemaps: None

#### Test Build

* Config: config.yml -> config.test.yml
* Jekyll Environment: production
* Command: `gulp build --t or --test`
* Minification: HTML, CSS, JS, etc
* Sourcemaps: None

Build mimicks the Production Build except for using relative paths(baseurl: ''). Used for Pull Request Previews(Deploy Previews) staging environments before merging into Production.

#### Development Build

* Config: config.yml -> config.dev.yml
* Jekyll Environment: development
* Command: `gulp build --d or --dev or --development`
* Minification: None
* Sourcemaps: CSS, JS

Build is used for local development and branch deploys for the staging environments.

## Commands

#### Flags

##### `--d or --dev or --development`

###### Development Build

```
HTML: Standard
Styles: Expanded with Inline Sourcemaps, Order Properties, Autoprefixer.
JS: Expanded with Inline Sourcemaps, ES2015.
Images: Optimized
```

##### `--t or --test`

###### Test Build

```
HTML: Minified
Styles: Compressed with no Sourcemaps, Order Properties, Autoprefixer, CleanCss.
JS: Compressed with no Sourcemaps, ES2015, Uglify.
Images: Optimized
```

##### `No -d or -t`

###### Production Build (default)

```
HTML: Minified
Styles: Compressed with no Sourcemaps, Order Properties, Autoprefixer, CleanCss.
JS: Compressed with no Sourcemaps, ES2015, Uglify.
Images: Optimized
```

#### Main

##### `gulp build` or `gulp`

Build a new site.

###### Sequenced Run Commands:

```
1. clean
2. build:images
3. build:fonts
4. build:scripts
5. build:styles
6. build:jekyll
7. build:html
```

##### `gulp serve`

Static Server + watching files. Only rebuild site if `--rebuild` option is passed to serve command.

###### Sequenced Run Commands:

```
1. build <- If flagged with --rebuild
2. watch
```

_Note:_ By default, `gulp serve` runs as a Development Build because its intended to run locally only. If you'd like to see what Production Build on `gulp serve` would look like, run with the `--test` flag.

##### `gulp watch`

Watches for site changes to stream or rebuild static build. Uses **BrowserSync** to server static build, middleware for 404 errors and pretty/vanity urls, Self Signed Certificate for https. _Note:_ By default, `gulp serve` runs as a Development Build because its intended to run locally only. If you'd like to see what Production Build on `gulp serve` would look like, run with the `--test` flag.

##### `gulp reload`

Reloading via BrowserSync

##### `gulp clean`

Deletes entire processed build, `_sites` directory.

#### Jekyll

##### `gulp build:jekyll`

Runs the Jekyll build command.

###### Flags

```
Development Build: --d or --dev or --development
Test Build: --t or --test
```

##### `gulp jekyll:check`

Special task for checking your Jekyll Setup.

```
Development Build: --d or --dev or --development
Test Build: --t or --test
```

##### `gulp watch:jekyll`

Special task for building the site then reloading via BrowserSync.

###### Sequenced Run Commands:

```
1. build:jekyll
2. build:html
3. reload
```

#### Styles

##### `gulp build:styles`

Builds all site styles.

###### Sequenced Run Commands:

```
1. build:styles:embed
2. build:styles:main
3. build:styles:css
```

##### `gulp build:styles:main`

Main site SCSS stylesheets, the target import stylesheet is `_assets/styles/styles.scss`. Uses Sass compiler to process styles, adds vendor prefixes, minifies, then outputs file to the appropriate location for appropriate environments.

##### `gulp build:styles:embed`

SCSS stylesheets for embedding styles throughout the theme. Any SCSS stylesheet that is prefixed with `embed-` will be processed then added to the `_html/includes/css` to for usage. Use Jekyll Tag `{% embed_css src:'PATH' %}` to embed styles into markup.

##### `gulp build:styles:css`

For vendor or plain css, add to the `_assets/styles/_css` directory. This copies stylesheets to the build directory for usage.

##### `gulp clean:styles`

Deletes all processed site styles.

#### Scripts

##### `gulp build:scripts`

Concatenates and uglifies global JS files and outputs result to the appropriate location for appropriate environments.

##### `gulp watch:scripts`

Watches for javascript changes, rebuilds the them then reload BrowserSync.

##### `gulp clean:scripts`

Deletes all processed scripts.

#### Images

##### `gulp build:images`

Builds and optimizes all site images/files.

###### Sequenced Run Commands:

```
1. build:images:site
2. build:images:media
3. optimize:images
```

##### `gulp build:images:site`

Copies theme specific images/files into image build directory. File types: `png, jpg, jpeg, gif, svg`

##### `gulp build:images:media`

Copies uploaded media images/files into image build directory. File types: `png, jpg, jpeg, gif, svg, pdf, zip, eps`

##### `gulp optimize:images`

Optimizes media and theme specific images/files.

##### `gulp clean:images`

Deletes all processed images.

#### Fonts

##### `gulp build:fonts`

Copies fonts for `_assets/fonts` to font build directory.

##### `gulp clean:fonts`

Deletes all processed fonts.

#### HTML

##### `gulp build:html`

Runs the HTML build command that minifies code in Test/Production Environments.

#### Misc.

##### `gulp update:gems`

Updates Ruby gems.

##### `gulp cache:clear`

Clears the gulp cache. Currently this just holds processed images.

##### `gulp accessibility:test`

Runs the accessibility test against WCAG standards.

## Need Help?

For questions, issues, deletions or additions, please feel free to submit a [issue request](https://github.com/HigherEducation/Jekyll/issues).

[websitetitle.com]: https://www.websitetitle.com/
[netlify]: https://www.netlify.com/

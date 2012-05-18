## Tuts+ Markdown

Converts GitHub Flavoured Markdown to Tuts+ HTML markup. Uses [Redcarpet](https://github.com/tanoku/redcarpet) for Markdown processing, with some customisations made for Tuts+ sites.

[Try out the web-based version of this converter!](http://blooming-stone-4663.herokuapp.com/)

Ensure you have the Redcarpet gem before using! `(sudo) gem install redcarpet`.

### Usage

```sh
$ ruby tuts+markdown.rb article.md
# 'article.md' converted and saved to 'article.html'
```

Or specify an output filename yourself:

```sh
$ ruby tuts+markdown.rb article.md output.html
# 'article.md' converted and saved to 'output.html'
```

### Why?

I prefer to write articles in Markdown. I keep all my articles in a private Git repo, on GitHub where they can be previewed. I find the GitHub way of delimiting code blocks best.

This takes that code and converts it to Tuts+ style HTML - including headings and code wrapping.


Before:

	Lorem _ipsum_ dolor __sit__ amet

	## This is a title

	Now for a line break.
	And some code :)

	```php
	<?php echo 'Hello, World!'; ?>
	```

	It even ensures the_middle_of words don't italicise, but _words_ do.

After:

```html
<p>Lorem <em>ipsum</em> dolor <strong>sit</strong> amet</p>

<br>
<h2>This is a title</h2>

<p>Now for a line break.<br>
And some code :)</p>

[php]
<?php echo 'Hello, World!'; ?>
[/php]

<p>It even ensures the_middle_of words don't italicise, but <em>words</em> do.</p>
```

:)
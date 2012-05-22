require 'sinatra'
require 'redcarpet'

class TutsMarkdown < Redcarpet::Render::HTML
	def block_code(code, language)
		"\n[#{language}]#{code}[/#{language}]\n"
	end

	def image(link, title, alt_text)
		"<!-- start img --><div class='tutorial_image'><img src='#{link}' alt='#{alt_text}' title='#{title}' border='0'></div><!-- end img -->"
	end

	def header(text, header_level)
		header_level = 2 if header_level == 1
		elem = "\n"
		elem += "<hr>\n" if header_level == 2
		elem += "<h#{header_level}>#{text}</h#{header_level}>"
	end
end

def convert(contents)
	markdown = Redcarpet::Markdown.new(TutsMarkdown, :fenced_code_blocks => true)

	# prevent foo_bar_baz from ending up with an italic word in the middle (modified from GFM)
	contents.gsub!(/(\w+_\w+_\w[\w_]*)/) do |x|
		x.gsub!('_', '\_') if x[0..1] != '__'
		x
	end

	# in very clear cases, let newlines become <br /> tags (modified from GFM)
	contents.gsub!(/(\A|^$\n)(^\w[^\n]*\n)(^\w[^\n]*$)+/m) do |x|
		x.gsub(/^(.+)$/, "\\1  ")
	end

	converted = markdown.render(contents)

	converted.gsub!('<p><!-- start img -->', '')
	converted.gsub!('<!-- end img --></p>', '')

	converted
end

get '/' do
	@title = 'Tuts+ Markdown Converter'
	erb :upload, :layout => :template
end

post '/' do
	unless params[:upload] &&
		   (tmpfile = params[:upload][:tempfile]) &&
		   (filename = params[:upload][:filename])
		@title = 'Tuts+ Markdown Converter'
		@error = 'No file selected'
		return erb :upload, :layout => :template
	end

	@title = 'Tuts+ Tutorial'

	file = File.open(tmpfile.path, 'rb')

	contents = file.read
	converted = convert(contents)
	converted = erb converted, :layout => :template

	output_filename = filename.chomp(File.extname(filename)) + '.html'

	# converted
	response.headers['content_type'] = "text/html"
	attachment(output_filename)
	response.write(converted)
end

__END__

@@ upload
<h2>Tuts+ Markdown Converter</h2>
<p class="desc">Upload your <code>.md</code> file below - we prefer <a href="http://github.github.com/github-flavored-markdown/" target="_blank">GitHub Flavoured Markdown</a>.</p>
<p>Your source will then be converted to Tuts+ formatted HTML, ready for submission!</p>
<form method="post" enctype="multipart/form-data">
	<input type="file" name="upload">
	<input type="submit" value="Convert">
</form>
<p><small>This app is open source. Find it on <a href="https://github.com/danharper/tutsplusmarkdown">GitHub</a>.</small></p>

@@ template
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
h1,
h2,
h3,
h4,
h5,
h6,
p,
blockquote {
	margin: 0;
	padding: 0;
}
body {
	font-family: "Helvetica Neue", Helvetica, "Hiragino Sans GB", Arial, sans-serif;
	font-size: 13px;
	line-height: 18px;
	color: #737373;
	margin: 10px 10px 10px 20px;
}
a {
	color: #0069d6;
}
a:hover {
	color: #0050a3;
	text-decoration: none;
}
a img {
	border: none;
}
p {
	margin-bottom: 9px;
}
h1,
h2,
h3,
h4,
h5,
h6 {
	color: #404040;
	line-height: 36px;
}
h1 {
	margin-bottom: 18px;
	font-size: 30px;
}
h2 {
	font-size: 24px;
}
h3 {
	font-size: 18px;
}
h4 {
	font-size: 16px;
}
h5 {
	font-size: 14px;
}
h6 {
	font-size: 13px;
}
hr {
	margin: 0 0 19px;
	border: 0;
	border-bottom: 1px solid #aaa;
}
blockquote {
	padding: 13px 13px 21px 15px;
	margin-bottom: 18px;
	font-family:georgia,serif;
	font-style: italic;
}
blockquote:before {
	content:"\201C";
	font-size:40px;
	margin-left:-10px;
	font-family:georgia,serif;
	color:#eee;
}
blockquote p {
	font-size: 14px;
	font-weight: 300;
	line-height: 18px;
	margin-bottom: 0;
	font-style: italic;
}
code, pre {
	padding: 0 3px 2px;
	font-family: Monaco, Andale Mono, Courier New, monospace;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius: 3px;
}
code {
	background-color: #fee9cc;
	color: rgba(0, 0, 0, 0.75);
	padding: 1px 3px;
	font-size: 12px;
}
pre {
	display: block;
	padding: 14px;
	margin: 0 0 18px;
	line-height: 16px;
	font-size: 11px;
	border: 1px dashed #ccc;
	border: 1px dashed rgba(0, 0, 0, 0.15);
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius: 3px;
	white-space: pre;
	white-space: pre-wrap;
	word-wrap: break-word;
}
pre code {
	background-color: #fdfdfd;
	color:#737373;
	font-size: 11px;
}

body > img:first-child {
	border: 5px solid #F0F0F0;
	float: left;
	margin: 0 10px 10px 0;
	width: 200px;
	height: 200px;
}
body > hr:first-of-type {
	display: none;
}
body > h2:first-of-type {
	border-top: none;
	padding-top: 0;
}
body > p:first-of-type {
	color: #888;
	font-size: 1.2em;
	font-style: italic;
	line-height: 1.4em;
	margin-top: 10px;
}
body > p.desc {
	font-style: normal;
}
body > p:first-of-type + p {
	border-top: 1px solid #eaeaea;
	clear: both;
	padding-top: 15px;
}
body > p.desc + p {
	border-top: none;
	padding: 0;
}
form {
	margin: 20px 0;
}
hr {
	border-bottom-color: #eaeaea;
	margin: 15px 0;
}
.tutorial_image {
	background-color: #F7F7F7;
	border-top: 1px solid white;
	border-bottom: 1px solid white;
	padding: 10px;
	text-align: center;
	margin-bottom: 10px;
}
.tutorial_image img {
	border: 1px solid #eaeaea;
}

@media screen and (min-width: 768px) {
	body {
		width: 748px;
		margin:10px auto;
	}
}
</style>
<title><%= @title %></title>
</head>
<body>

	<% if @error %>
		<p><%= @error %></p>
	<% end %>

	<%= yield %>

</body>
</html>
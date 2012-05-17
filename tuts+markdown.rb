require 'redcarpet'

unless (1..2) === ARGV.length
	puts "Syntax is: ruby tuts+markdown.rb filename [output_filename]"
	exit
end

filename = ARGV[0]
output_filename = ARGV[1] || filename.chomp(File.extname(filename)) + '.html'

unless File.exists?(filename)
	puts "File '#{filename}' not found"
	exit
end

file = File.open(ARGV[0], 'rb')
contents = file.read

class TutsMarkdown < Redcarpet::Render::HTML
	def block_code(code, language)
		"\n[#{language}]#{code}[/#{language}]\n"
	end

	def image(link, title, alt_text)
		"\n<div class='tutorial_image'><img src='#{link}' alt='#{alt_text}' title='#{title}' border='0'></div>\n"
	end

	def header(text, header_level)
		header_level = 2 if header_level == 1
		elem = "\n"
		elem += "<br>\n" if header_level == 2
		elem += "<h#{header_level}>#{text}</h#{header_level}>"
	end
end

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

converted = markdown.render(contents);

File.open(output_filename, 'w+') do |f|
	f.write(converted)
end

puts "'#{filename}' converted and saved as '#{output_filename}'"
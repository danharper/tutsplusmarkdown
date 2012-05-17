require 'redcarpet'

unless ARGV.length == 1
	puts "Syntax is: tuts+markdown.rb filename"
	exit
end

filename = ARGV[0]

unless File.exists?(filename)
	puts "File '#{filename}' not found"
	exit
end

file = File.open(ARGV[0], 'rb')
contents = file.read

class TutsMarkdown < Redcarpet::Render::HTML
	def block_code(code, language)
		"\n[#{language}]#{code}[#{language}]\n"
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

md = markdown.render(contents);

output_filename = filename.chomp(File.extname(filename)) + '.html'

File.open(output_filename, 'w+') do |f|
	f.write(md)
end

puts "'#{filename}' converted and saved to '#{output_filename}'"
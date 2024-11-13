require "time"
module Jekyll2Zola
  class Converter
    DEFINE_YAML_SEPARATOR = "---"
    DEFINE_TOML_SEPARATOR = "+++"
    YAML_VARIABLE_OPERATOR = ": "
    TOML_VARIABLE_OPERATOR = " = "
    def initialize(content_directory_from:, content_directory_to:, type_from: :yaml, type_to: :toml)
      @content_directory_from = content_directory_from
      @content_directory_to = content_directory_to
      @markdown_formatter_type_from = type_from
      @markdwon_fromatter_type_to = type_to
      @format_area_count = 0
    end
    def file_rename(from, to)
      File.rename(from, to)
      to
    end
    def convert!
      filenames = File.directory?(@content_directory_from) ? Dir.entries(@content_directory_from).reject { |v| v =~ /^\./ }.map { |v| [@content_directory_from, v].join("/") } : [@content_directory_from]
      destination = @content_directory_to
      filenames.each do |f|
        filename = File.basename(f, ".*")
        d = ([destination, filename].join("/")) + ".md"
        file_rename(f, d)
        content = convert_markdown_formatter(d)
        File.open(d, "wb") { |f| f.write(content.join) }
      end
    end
    def convert_markdown_formatter(filename, from_type: :yaml, to_type: :toml)
      cf = convert_format(from: from_type, to: to_type)
      markdown_content = File.open(filename).readlines
      @format_area_count = 0
      markdown_content.map { |line| convert_line(line) }.insert(1, insert_path(filename))
    end
    
    def insert_path(filename) = "path#{convert_format[:operator]}\"#{url_path(File.basename(filename, "*.md"))}\"\n"
    def url_path(filename) = filename.split(/-/).then { |(year, month, day, *base_name)| ["/blog", [year, month, day].join("/"), base_name.join("-").gsub(/\.m(arkdown|d)/,"")].join("/") }

    def convert_format(from: :yaml, to: :toml)
      @convert_format ||= {
        separator: eval("DEFINE_#{to.upcase}_SEPARATOR"),
        operator: eval("#{to.upcase}_VARIABLE_OPERATOR"),
      }
    end

    def convert_line(line)
      cf = @convert_format
      if line =~ /^(---|\+\+\+)$/ && line != cf[:separator] && @format_area_count < 2
        @format_area_count += 1
        cf[:separator] + "\n"
      elsif line =~ /^date/ && @format_area_count < 2
        "date#{cf[:operator]}#{Time.parse(line.sub(/date(:| =)/, "")).strftime("%Y-%m-%d")}\n"
      elsif (md = /^(?<key>.+?)(#{YAML_VARIABLE_OPERATOR}|#{TOML_VARIABLE_OPERATOR})(?<val>.+?)$/.match(line)) && @format_area_count < 2
        _, key, val = md.to_a
        val = val =~ /"|true|false/ ? val : "\"#{val}\""
        [key, val].join(cf[:operator]) + "\n"
      else
        line
      end
    end
  end
end

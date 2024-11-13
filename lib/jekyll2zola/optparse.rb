require "optparse"
module Jekyll2Zola
  class OptionParser
    attr_reader :options
    def initialize
      @option_parser = ::OptionParser.new
      @options = {}
    end

    def options!
      @option_parser.on("-i VAL", "--import-from VAL") { |v| @options[:content_directory_from] = v }
      @option_parser.on("-d VAL", "--export-to VAL") { |v| @options[:content_directory_to] = v }
    end

    def parse!(args)
      options!

      @option_parser.parse!(args)
      self
    end
  end
end

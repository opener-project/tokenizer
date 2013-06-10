require_relative "tokenizer/version"
require_relative "tokenizer/option_parser"
require 'nokogiri'

module Opener
  class Tokenizer
    attr_reader :args, :text
    attr_accessor :options
    
    def initialize(opts={}, text)
      @text    = text
      reader = Nokogiri::XML::Reader(text)
      reader.read
      puts reader.attribute('xml::lang')
      @args    = opts.delete(:args) || []
      @options = opts
    end
    
    def options
      OptionParser.parse(args.dup).merge(@options)
    end
    
    def identify
      if options[:kaf]
        kaf_input
      else
        raw_input
      end
    end
    
    protected

    def kaf_input
     klass_for_language.new
    end

    def raw_input
      klass_for_language.new
    end
    
    def klass_for_language
      Object.const_get "Opener::Tokenizers::#{options[:language].upcase}"
    end
    
  end
end
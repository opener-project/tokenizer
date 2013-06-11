require_relative "tokenizer/version"
require_relative "tokenizer/option_parser"
require "opener/tokenizers/base"
require "opener/tokenizers/fr"
require "nokogiri"
require "open3"

module Opener
  class Tokenizer
    attr_reader :args
    attr_accessor :options
    
    def initialize(opts={})
      @args    = opts.delete(:args) || []
      @options = opts
    end
    
    def options
      OptionParser.parse(args.dup).merge(@options)
    end
    
    def tokenize(text)
      language = options[:language]
      
      if options[:kaf]
        language, text = get_kaf_elements(text)
      end
      
      tokenizer = tokenizer_for_language(language)
      output, error, process = Open3.capture3(tokenizer.command, :stdin_data=>text)
    end
    
    alias :run :tokenize
    
    protected

    def tokenizer_for_language(language)
      Opener::Tokenizers.const_get(language.upcase).new
    end
    
    def get_kaf_elements(text)
      doc = Nokogiri::XML(text)
      language = doc.at('KAF').attr('xml:lang')
      raw_text = doc.at('raw').text

      check_language_support(language)
      return [language, raw_text]
    end
    
    def check_language_support(language)
      OptionParser.check_language!(language)
    end    
  end
end
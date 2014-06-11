require 'opener/tokenizers/base'
require 'nokogiri'
require 'open3'
require 'optparse'

require_relative 'tokenizer/version'
require_relative 'tokenizer/cli'
require_relative 'tokenizer/error_layer'

module Opener
  ##
  # Primary tokenizer class that delegates the work to the various language
  # specific tokenizers.
  #
  # @!attribute [r] options
  #  @return [Hash]
  #
  class Tokenizer
    attr_reader :options

    ##
    # The default language to use when no custom one is specified.
    #
    # @return [String]
    #
    DEFAULT_LANGUAGE = 'en'.freeze

    ##
    # Hash containing the default options to use.
    #
    # @return [Hash]
    #
    DEFAULT_OPTIONS = {
      :args     => [],
      :kaf      => true,
      :language => DEFAULT_LANGUAGE
    }.freeze

    ##
    # @param [Hash] options
    #
    # @option options [Array] :args Collection of arbitrary arguments to pass
    #  to the individual tokenizer commands.
    # @option options [String] :language The language to use for the
    #  tokenization process.
    # @option options [TrueClass|FalseClass] :kaf When set to `true` the input
    #  is assumed to be KAF.
    #
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end

    ##
    # Processes the input and returns an array containing the output of STDOUT,
    # STDERR and an object containing process information.
    #
    # @param [String] input
    # @return [Array]
    #
    def run(input)
      begin
        if options[:kaf]
          language, input = kaf_elements(input)
        else
          language = options[:language]
        end
      
        kernel = language_constant(language).new(:args => options[:args])

        return Open3.capture3(*kernel.command.split(" "), :stdin_data => input)
      rescue Exception => error
        return ErrorLayer.new(input, error.message, self.class).add
      end
    end

    alias tokenize run

    private

    ##
    # Returns an Array containing the language an input from a KAF document.
    #
    # @param [String] input The KAF document.
    # @return [Array]
    #
    def kaf_elements(input)
      document = Nokogiri::XML(input)
      language = document.at('KAF').attr('xml:lang')
      text     = document.at('raw').text

      return language, text
    end

    ##
    # @param [String] language
    # @return [Class]
    #
    def language_constant(language)
      Opener::Tokenizers.const_get(language.upcase)
    end

    ##
    # @return [TrueClass|FalseClass]
    #
    def valid_language?(language)
      return Opener::Tokenizers.const_defined?(language.upcase)
    end
  end # Tokenizer
end # Opener

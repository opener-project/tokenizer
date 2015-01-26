require 'open3'

require 'opener/core'
require 'opener/tokenizers/base'
require 'nokogiri'
require 'slop'

require_relative 'tokenizer/version'
require_relative 'tokenizer/cli'

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
    #
    # @option options [String] :language The language to use for the
    #  tokenization process.
    #
    # @option options [TrueClass|FalseClass] :kaf When set to `true` the input
    #  is assumed to be KAF.
    #
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end

    ##
    # Tokenizes the input and returns the results as a KAF document.
    #
    # @param [String] input
    # @return [String]
    #
    def run(input)
      if options[:kaf]
        language, input = kaf_elements(input)
      else
        language = options[:language]
      end

      unless valid_language?(language)
        raise Core::UnsupportedLanguageError, language
      end

      kernel = language_constant(language).new(:args => options[:args])

      stdout, stderr, process = Open3.capture3(
        *kernel.command.split(" "),
        :stdin_data => input
      )

      raise stderr unless process.success?

      return stdout
    end

    alias tokenize run

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

    private

    ##
    # @param [String] language
    # @return [Class]
    #
    def language_constant(language)
      name = Core::LanguageCode.constant_name(language)

      Tokenizers.const_get(name)
    end

    ##
    # @return [TrueClass|FalseClass]
    #
    def valid_language?(language)
      name = Core::LanguageCode.constant_name(language)

      return Tokenizers.const_defined?(name)
    end
  end # Tokenizer
end # Opener

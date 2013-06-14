module Opener
  class Tokenizer
    ##
    # CLI wrapper around {Opener::Tokenizer} using OptionParser.
    #
    # @!attribute [r] options
    #  @return [Hash]
    # @!attribute [r] option_parser
    #  @return [OptionParser]
    #
    class CLI
      attr_reader :options, :option_parser

      ##
      # @param [Hash] options
      #
      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)

        @option_parser = OptionParser.new do |opts|
          opts.program_name   = 'tokenizer'
          opts.summary_indent = '  '

          opts.on('-h', '--help', 'Shows this help message') do
            show_help
          end

          opts.on('-v', '--version', 'Shows the current version') do
            show_version
          end

          opts.on(
            '-l',
            '--language [VALUE]',
            'Uses this specific language'
          ) do |value|
            @options[:language] = value
          end

          opts.on('-k', '--kaf', 'Treats the input as a KAF document') do
            @options[:kaf] = true
          end

          opts.separator <<-EOF

Examples:

  cat example.txt | #{opts.program_name} -l en # Manually specify the language
  cat example.kaf | #{opts.program_name}       # Uses the xml:lang attribute

Languages:

  * Dutch (nl)
  * English (en)
  * French (fr)
  * German (de)
  * Italian (it)
  * Spanish (es)

KAF Input:

  If you give a KAF file as an input (-k or --kaf) the language is taken from
  the xml:lang attribute inside the file. Else it expects that you give the
  language as an argument (-l or --language)

Sample KAF syntax:

  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <KAF version="v1.opener" xml:lang="en">
    <raw>This is some text.</raw>
  </KAF>
          EOF
        end
      end

      ##
      # @param [String] input
      #
      def run(input)
        option_parser.parse!(options[:args])

        tokenizer = Tokenizer.new(options)

        stdout, stderr, process = tokenizer.run(input)

        if process.success?
          puts stdout

          STDERR.puts(stderr) unless stderr.empty?
        else
          abort stderr
        end
      end

      private

      ##
      # Shows the help message and exits the program.
      #
      def show_help
        abort option_parser.to_s
      end

      ##
      # Shows the version and exits the program.
      #
      def show_version
        abort "#{option_parser.program_name} v#{VERSION} on #{RUBY_DESCRIPTION}"
      end
    end # CLI
  end # Tokenizer
end # Opener

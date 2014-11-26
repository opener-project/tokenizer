module Opener
  class Tokenizer
    ##
    # CLI wrapper around {Opener::Tokenizer} using Slop.
    #
    # @!attribute [r] parser
    #  @return [Slop]
    #
    class CLI
      attr_reader :parser

      def initialize
        @parser = configure_slop
      end

      ##
      # @param [Array] argv
      #
      def run(argv = ARGV)
        parser.parse(argv)
      end

      ##
      # @return [Slop]
      #
      def configure_slop
        return Slop.new(:strict => false, :indent => 2, :help => true) do
          banner 'Usage: tokenizer [OPTIONS]'

          separator <<-EOF.chomp

About:

    Tokenizer for KAF/plain text documents with support for various languages
    such as Dutch and English. This command reads input from STDIN.

Examples:

    cat example.txt | tokenizer -l en # Manually specify the language
    cat example.kaf | tokenizer       # Uses the xml:lang attribute

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

Example KAF:

    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <KAF version="v1.opener" xml:lang="en">
      <raw>This is some text.</raw>
    </KAF>
          EOF

          separator "\nOptions:\n"

          on :v, :version, 'Shows the current version' do
            abort "tokenizer v#{VERSION} on #{RUBY_DESCRIPTION}"
          end

          on :l=, :language=, 'A specific language to use',
            :as      => String,
            :default => DEFAULT_LANGUAGE

          on :k, :kaf, 'Treats the input as a KAF document'
          on :p, :plain, 'Treats the input as plain text'

          run do |opts, args|
            tokenizer = Tokenizer.new(
              :args     => args,
              :kaf      => opts[:plain] ? false : true,
              :language => opts[:language]
            )

            input = STDIN.tty? ? nil : STDIN.read

            puts tokenizer.run(input)
          end
        end
      end
    end # CLI
  end # Tokenizer
end # Opener

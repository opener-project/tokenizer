require 'optparse'

module Opener
  class Tokenizer
    class OptionParser

      def self.parse(options_array)
        options = {}
        ::OptionParser.new do |opts|
          opts.banner = "\nUsage: cat some_text.txt | tokenizer [options]\n\n"

          opts.on("-k", "--kaf", "Input is a KAF file with the xml:lang attribute set and the raw text.") do |v|
            options[:kaf] = v
          end
          
          opts.on("-l", "--language [LANG]", "Inputs language attribute as an argument.") do |v|
            check_language!(v)
            options[:language] = v
          end

          opts.separator "\n"
          opts.separator <<-EOF.strip

      Languages that can be tokenized:

        english (en), french (fr), spanish (es), italian (it) german (de) and dutch (nl)

        If you give a KAF file as an input (-k or --kaf) the language is taken from the xml:lang
        attribute inside the file. Else it expects that you give the language as an argument (-l or --language)

          EOF

        end.parse!(options_array)
        return options
      end
      
      def self.check_language!(language)
        raise STDERR.puts "'#{language}' language cannot be tokenized" if !language_list.include?(language.downcase)
      end
    
      def self.language_list
        ['en', 'fr', 'es', 'it', 'de', 'nl']
      end
      
    end
  end
end

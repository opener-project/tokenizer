require 'optparse'

module Opener
  class Tokenizer
    class OptionParser

      def self.parse(options_array)
        options = {}
        ::OptionParser.new do |opts|
          opts.banner = "\nUsage: cat some_text.txt | tokenizer [options]\n\n"
          
          opts.on("-l", "--language [LANG]", "Inputs language attribute as an argument.") do |v|
            check_language!(v)
            options[:language] = v
          end

          opts.on("-k", "--kaf", "Input is a KAF file with the xml:lang attribute set and the raw text.") do
            options[:kaf] = true
          end
          


          opts.separator "\n"
          opts.separator <<-EOF.strip

      Languages that can be tokenized:

        english (en), french (fr), spanish (es), italian (it) german (de) and dutch (nl)

        If you give a KAF file as an input (-k or --kaf) the language is taken from the xml:lang
        attribute inside the file. Else it expects that you give the language as an argument (-l or --language)
        
        Sample KAF syntax:
        
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <KAF version="v1.opener" xml:lang="en">
          <raw>
            This is some text.
          </raw>
        </KAF>

          EOF

        end.parse!(options_array)
        return options
      end
      
      def self.check_language!(language)
        abort "'#{language}' language cannot be tokenized." if !language_list.include?(language.downcase)
      end
    
      def self.language_list
        ['en', 'fr', 'es', 'it', 'de', 'nl']
      end
      
    end
  end
end

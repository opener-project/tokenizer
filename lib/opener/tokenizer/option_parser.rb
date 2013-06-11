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
          


          opts.separator ""

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

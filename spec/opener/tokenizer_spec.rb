require 'spec_helper'

describe Opener::Tokenizer do
  before do
    @input = <<-EOF
<KAF version="v1.opener" xml:lang="en">
  <raw>Hello world</raw>
</KAF>
    EOF
  end

  context '#run' do
    example 'raise UnsupportedLanguageError for unsupported languages' do
      tokenizer = described_class.new(:language => 'bacon', :kaf => false)
      block     = -> { tokenizer.run('foo') }

      block.should raise_error(
        Opener::Core::UnsupportedLanguageError,
        /The language "bacon"/
      )
    end

    example 'return a tokenized KAF document' do
      output   = described_class.new.run(@input)
      document = Nokogiri::XML(output)

      document.xpath('KAF/text/wf').length.should == 2
    end
  end

  context '#kaf_elements' do
    before do
      @tokenizer = described_class.new
    end

    example 'return the language of a document' do
      @tokenizer.kaf_elements(@input)[0].should == 'en'
    end

    example 'return the text of a document' do
      @tokenizer.kaf_elements(@input)[1].should == 'Hello world'
    end
  end
end

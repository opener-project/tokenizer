require File.expand_path('../lib/opener/tokenizer', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-tokenizer'
  gem.version               = Opener::Tokenizer::VERSION
  gem.authors               = ['development@olery.com']
  gem.summary               = 'Gem that wraps up the different existing tokenizers'
  gem.description           = gem.summary
  gem.homepage              = 'http://opener-project.github.com/'
  gem.has_rdoc              = "yard"
  gem.required_ruby_version = ">= 1.9.2"

  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end

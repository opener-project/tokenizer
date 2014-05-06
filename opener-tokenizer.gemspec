require File.expand_path('../lib/opener/tokenizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-tokenizer'
  gem.version               = Opener::Tokenizer::VERSION
  gem.authors               = ['development@olery.com']
  gem.summary               = 'Gem that wraps up the the tokenizer cores'
  gem.description           = gem.summary
  gem.homepage              = 'http://opener-project.github.com/'
  gem.has_rdoc              = "yard"

  gem.files       = `git ls-files`.split("\n")
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'opener-tokenizer-base', '>= 0.3.1'
  gem.add_dependency 'opener-webservice'

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'sinatra', '~>1.4.2'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'opener-daemons'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end

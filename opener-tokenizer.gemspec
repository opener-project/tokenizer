require File.expand_path('../lib/opener/tokenizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'opener-tokenizer'
  gem.version     = Opener::Tokenizer::VERSION
  gem.authors     = ['development@olery.com']
  gem.summary     = 'Gem that wraps up the the tokenizer cores'
  gem.description = gem.summary
  gem.homepage    = 'http://opener-project.github.com/'
  gem.has_rdoc    = "yard"

  gem.license = 'Apache 2.0'

  gem.required_ruby_version = '>= 1.9.2'

  gem.files = Dir.glob([
    'exec/**/*',
    'lib/**/*',
    'config.ru',
    '*.gemspec',
    'README.md',
    'LICENSE.txt'
  ]).select { |file| File.file?(file) }

  gem.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'opener-tokenizer-base', '~> 1.0'
  gem.add_dependency 'opener-webservice', '~> 2.1'
  gem.add_dependency 'opener-daemons', '~> 2.1'
  gem.add_dependency 'opener-core', '~> 2.0'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
end

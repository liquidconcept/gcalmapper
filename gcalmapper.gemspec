# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gcal_mapper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Néville Dubuis']
  gem.email         = ['neville.dubuis@liquid-concept.ch']
  gem.description   = %q{A library to map Google Calendar events with an ORM}
  gem.summary       = %q{A library to map Google Calendar events with an ORM}
  gem.homepage      = 'http://rubygems.org/gems/gcalmapper'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'gcalmapper'
  gem.require_paths = ['lib']
  gem.version       = Gcalmapper::VERSION
  
  gem.add_development_dependency 'rspec',         '>= 2.0'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'fakeweb'

end

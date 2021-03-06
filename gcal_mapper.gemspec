# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gcal_mapper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Néville Dubuis']
  gem.email         = ['neville.dubuis@liquid-concept.ch']
  gem.description   = %q{A library to map Google Calendar events with an ORM}
  gem.summary       = %q{A library to map Google Calendar events with an ORM}
  gem.homepage      = 'http://rubygems.org/gems/gcal_mapper'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['gcal-mapper']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'gcal_mapper'
  gem.require_paths = ['lib']
  gem.version       = GcalMapper::VERSION

  gem.add_dependency 'launchy'

  gem.add_development_dependency 'activerecord'
  gem.add_development_dependency 'rspec',   '>= 2.0'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'fakeweb'

end

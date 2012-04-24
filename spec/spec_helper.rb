require 'rubygems'
require 'spork'
require 'rspec'

# SimpleCov
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'vendor'
  end
end

Spork.prefork do
  #vcr 
  require 'vcr'
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into :fakeweb
    c.configure_rspec_metadata!
    c.default_cassette_options = {
      record: :new_episodes,
      allow_playback_repeats: true
    }
  end
  
  RSpec.configure do |config|
    config.filter_run :focus
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
  end

end

Spork.each_run do

end
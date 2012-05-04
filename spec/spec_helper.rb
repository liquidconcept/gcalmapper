require 'rubygems'
require 'spork'
require 'rspec'


# SimpleCov
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 
end

require 'gcal_mapper'

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
    config.filter_run :focus => true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.before :all do
      @p12 = 'spec/file/privatekey.p12'
      @client_email = '491507701942-7bc0pf4187fooffdqp6ao1a0b81v6aj2@developer.gserviceaccount.com'
      @user_email = 'neville.dubuis@liquid-concept.ch'
      @yaml = 'spec/file/.google-api.yaml'
      @yaml_relative = '~/.google-api.yaml'
      @bad_yaml = 'spec/file/bad_yaml.yaml'
      @calendar_id = 'neville.dubuis@liquid-concept.ch'
    end
  end

  
end

Spork.each_run do

end
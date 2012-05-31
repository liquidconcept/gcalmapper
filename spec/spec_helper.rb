require 'rubygems'
require 'spork'
require 'rspec'
require 'active_record'


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
      ActiveRecord::Base.establish_connection(
       :adapter => "sqlite3",
       :database => File.dirname(__FILE__) + "/test.sqlite3"
      )
      load File.dirname(__FILE__) + '/support/schema.rb'

      config = YAML.load_file('spec/file/config.yaml')
      @p12 = config['p12']
      @client_email = config['client_email']
      @user_email = config['user_email']
      @yaml = config['yaml']
      @yaml_relative = config['yaml_relative']
      @bad_yaml = config['bad_yaml']
      @calendar_id = config['calendar_id']
    end
  end


end

Spork.each_run do

end
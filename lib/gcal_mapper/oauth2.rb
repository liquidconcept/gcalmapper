require 'google/api_client'
require 'yaml'
require 'json'

module GcalMapper
  
  #
  # make the authentification with Oauth2 and request data from google calendar.
  #
  class Oauth2
    
    # the object [Google::APIClient] from google-api-client
    attr_accessor :client_id, :client_secret, :scope, :refresh_token, :access_token

    
    # intialize client info needed for connection to Oauth2.
    #
    # @param [String] yaml_file path to the yaml file which contains acess token, ...
    def initialize (yaml_file)
      oauth_yaml = YAML.load_file(yaml_file)
      @client_id = oauth_yaml["client_id"]
      @client_secret = oauth_yaml["client_secret"]
      @scope = oauth_yaml["scope"]
      @refresh_token = oauth_yaml["refresh_token"]
      @access_token = oauth_yaml["access_token"]
    end
    
  end
end
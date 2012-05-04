require 'gcal_mapper/authentification/base'
require 'yaml'

module GcalMapper
  class Authentification
    #
    # make the authentification with Oauth2 and request data from google calendar.
    #
    class Oauth2 < Authentification::Base

      attr_accessor :refresh_token  # refresh token to request new acces token
      attr_accessor :access_token   # access token needed to use api

      # intialize client info needed for connection to Oauth2.
      #
      # @param [String] yaml_file path to the yaml file which contains acess token, ...
      def initialize (yaml_file)
        begin
          oauth_yaml = YAML.load_file(yaml_file)
          @client_id = oauth_yaml["client_id"]
          @client_secret = oauth_yaml["client_secret"]
          @scope = oauth_yaml["scope"]
          @refresh_token = oauth_yaml["refresh_token"]
          @access_token = oauth_yaml["access_token"]
        rescue
          raise GcalMapper::AuthFileError
        end
      end

    end
  end
end
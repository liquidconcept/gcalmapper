require 'gcal_mapper/authentification/base'
require 'yaml'

module GcalMapper
  class Authentification
    #
    # make the authentification with Oauth2 and request data from google calendar.
    #
    class Oauth2 < Authentification::Base

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
          @validity = Time.now.getutc.to_i
        rescue
          raise GcalMapper::AuthFileError
        end
      end

      # give the acess token for th application and refresh if it is outdated
      #
      # @return [String] access token
      def access_token
        if (Time.now.getutc.to_i - @validity) > 3600
          refresh_token
        end

        @access_token
      end

      # refresh the token by using refresh token
      #
      # @return [String] access token
      def refresh_token
        url = 'https://accounts.google.com/o/oauth2/token'
        data = {
          'client_id' => @client_id,
          'client_secret' => @client_secret,
          'refresh_token' => @refresh_token,
          'grant_type' => 'refresh_token'
        }
        options = {
          :method => :post,
          :headers => {'Content-Type' => 'application/x-www-form-urlencoded'},
          :parameters => data
        }
        req = GcalMapper::RestRequest.new(url, options)
        begin
          response = req.execute
        rescue
          raise GcalMapper::AuthentificationError
        end
        @validity = Time.now.getutc.to_i

        @access_token = response['access_token']
        response
      end

    end
  end
end
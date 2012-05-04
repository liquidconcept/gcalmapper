require 'gcal_mapper/authentification/base'
require 'base64'
require 'json'

module GcalMapper
  class Authentification
    #
    # make the authentification for service account and request data from google calendar.
    #
    class Assertion < Authentification::Base

      attr_accessor :client_email   # the email given by google for the service account
      attr_accessor :p12_file       # the path to the p12 file that contains the private key
      attr_accessor :password       # the password to the private key file
      attr_accessor :access_token   #the token return by google

      # New object
      #
      # @param [String] client_email the email given by google for the service account
      # @param [String] p12_file the path to the p12 file that contains the private key
      # @param [String] password the password to the private key file
      def initialize(p12_file, client_email, password='notasecret')
        @client_email = client_email
        @p12_file = p12_file
        @password = password
        @access_token = request_token['access_token']
      end

      # generate the JWT that must be include with the request acess token.
      # the format of the JWT is (base64url encoded header).(base64url encoded claim set).(base64url encoded signature)
      #
      # @return [String] the generate JWT.
      def generate_assertion()
        header = {'alg' => 'RS256', 'typ' => 'JWT'}
        encoded_header = Base64.urlsafe_encode64(header.to_json)

        utc_time = Time.now.getutc.to_i
        claim = {
          'aud' => 'https://accounts.google.com/o/oauth2/token',
          'scope'=>'https://www.googleapis.com/auth/calendar.readonly',
          'iat' => utc_time,
          'exp' => utc_time+3600,
          'iss' => @client_email
        }
        encoded_claim = Base64.urlsafe_encode64(claim.to_json)
        begin
          p12 = OpenSSL::PKCS12.new(File.read(@p12_file), @password)
        rescue
          raise GcalMapper::AuthFileError
        end
        key = p12.key
        sign = key.sign(OpenSSL::Digest::SHA256.new, encoded_header + '.' + encoded_claim)
        encoded_sign = Base64.urlsafe_encode64(sign)

        encoded_header + '.' + encoded_claim + '.' + encoded_sign
      end

      # Prepare all the parameters for sending the request token request to google
      # and save the token in instance variable.
      #
      # @return [Hash] the HTTP response.
      def request_token()
        url = 'https://accounts.google.com/o/oauth2/token'
        data = {
          'grant_type' => 'assertion',
          'assertion_type' => 'http://oauth.net/grant_type/jwt/1.0/bearer',
          'assertion' => generate_assertion
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

        response
      end

    end
  end
end
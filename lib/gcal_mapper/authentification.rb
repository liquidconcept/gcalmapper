require 'gcal_mapper/authentification/assertion'
require 'gcal_mapper/authentification/oauth2'

module GcalMapper
  #
  # Abstract which type of authentification is required
  #
  class Authentification

    attr_reader :file           # file that is needed for authentification
    attr_reader :client_email   # for assertion authentification
    attr_reader :password       # password for the p12 file

    # intialize client info needed for connection to Oauth2.
    #
    # @param [String] file path to the yaml or p12 file
    # @param [String] client_email email from the api_consol (service account only)
    # @param [String] user_email email from the impersonated user (service account only)
    # @param [String] password p12 key password (service account only)
    def initialize(file, client_email=nil, user_email=nil, password='notasecret')
      @file = File.expand_path(file)
      @client_email = client_email
      @user_email = user_email
      @password = password
      raise GcalMapper::AuthFileError if !File.exist?(@file)
    end

    # do the authentification for one of the right authentification method
    #
    # @return [Bool] true if instantiation ok
    def authenticate
      if client_email==nil
        @auth = Authentification::Oauth2.new(@file)
      else
        @auth = Authentification::Assertion.new(@file, @client_email, @user_email, @password)
      end

      !access_token.nil?
    end

    # Gives the access token
    #
    # @return [string] the access token
    def access_token
      @auth.access_token
    end

  end
end
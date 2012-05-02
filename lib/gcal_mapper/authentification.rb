module GcalMapper
  #
  # Abstract which type of authentification is required
  #
  class Authentification
    
    attr_accessor :file, :client_email, :password, :auth
    
    # intialize client info needed for connection to Oauth2.
    #
    # @param [String] file path to the yaml or p12 file
    # @param [String] client_email client email of service accout if you use p12 file
    # @param [String] password password of the p12 file
    def initialize(file, client_email=nil, password='notasecret')
      @file = File.expand_path(file)
      @client_email = client_email
      @password = password
      raise Exception.new("File don't exist") if !File.exist?(@file) 
    end
    
    # do the authentification for one of the right authentification method
    #
    # @return [Bool] true if instantiation ok
    def authenticate
      if client_email==nil
        @auth = GcalMapper::Oauth2.new(@file)
      else
        @auth = GcalMapper::Assertion.new(@file, @client_email, @password)
      end
      access_token!=nil
    end
    
    # Gives the access token
    #
    # @return [string] the access token
    def access_token
      @auth.access_token
    end
  end
end
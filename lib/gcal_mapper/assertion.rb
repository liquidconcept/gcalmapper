require 'base64'
require 'net/http'
require 'json'

module GcalMapper
  #
  # make the authentification for service account and request data from google calendar.
  #
  class Assertion
    
    # the email given by google for the service account
    attr_accessor :client_email 
    # the path to the p12 file that contains the private key
    attr_accessor :p12_file
    # the password to the private key file 
    attr_accessor :password
    #the token return by google
    attr_accessor :access_token
    
    # New object
    #
    # @param [String] client_email the email given by google for the service account
    # @param [String] p12_file the path to the p12 file that contains the private key
    # @param [String] password the password to the private key file
    def initialize(client_email, p12_file, password='notasecret')
      @client_email = client_email
      @p12_file = p12_file
      @password = password
    end
    
    
    # generate the JWT that must be include with the request acess token.
    # the format of the JWT is (base64url encoded header).(base64url encoded claim set).(base64url encoded signature)
    #
    # @return [String] the generate JWT.
    def generate_assertion()
  
      # generating JWT
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
  
      p12 = OpenSSL::PKCS12.new(File.read(@p12_file), @password)
      key = p12.key
      sign = key.sign(OpenSSL::Digest::SHA256.new, encoded_header + '.' + encoded_claim)
      encoded_sign = Base64.urlsafe_encode64(sign)
  
      jwt = encoded_header + '.' + encoded_claim + '.' + encoded_sign
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
        
      response = execute(url, options)
      body = JSON.parse(response.body)
      @access_token = body['access_token']
      body
    end
    
    # Prepare the request to obtain the list of accessible calendar.
    #
    # @return [Hash] the HTTP response.
    def get_calendar_list()
      url = 'https://www.googleapis.com/calendar/v3/calendars/liquid-concept.ch_faut85h1u3h2u983d4eho2ropk@group.calendar.google.com/events'
      options = {
        :method => :get,
        :headers => {'Authorization' => 'Bearer ' + @acess_token}
      }
      response = execute(url, options)
      body = JSON.parse(response.body)
    end
    
    # Set the proxy as environement variable.
    #
    def proxy
      http_proxy = ENV["http_proxy"]
      URI.parse(http_proxy) rescue nil
    end
    
    # Execute REST request 
    #
    # @param [String] url the complete url of where to send the request
    # @param [Hash] option contain all the options that can be included in REST request
    # @return [Sting] the response of the request.
    def execute(url, options = {})
      options = { :parameters => {}, :debug => false, 
                  :http_timeout => 60, :method => :get, 
                  :headers => {}, :redirect_count => 0, 
                  :max_redirects => 10 }.merge(options)
 
      url = URI(url)
         
      if proxy
        http = Net::HTTP::Proxy(proxy.host, proxy.port).new(url.host, url.port)
      else
        http = Net::HTTP.new(url.host, url.port)
      end
     
      if url.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
         
      http.open_timeout = http.read_timeout = options[:http_timeout]
      
      http.set_debug_output $stderr if options[:debug]
      
      request = case options[:method]
        when :post
          request = Net::HTTP::Post.new(url.request_uri)
          request.set_form_data(options[:parameters])
          request
        else
          request = Net::HTTP::Get.new(url.request_uri)
      end
 
      options[:headers].each { |key, value| request[key] = value }
      response = http.request(request)
    end 
  end
end
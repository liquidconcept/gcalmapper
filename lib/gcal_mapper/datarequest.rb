require 'net/http'

module GcalMapper
  #
  # Make a REST get or post request
  #
  class Datarequest
    
    # Complete url for the request
    attr_accessor :url
    # Options for the REST request
    attr_accessor :options
    
    def initialize (url, options = {})
      @url = url
      @options = options
    end
    
    # Set a proxy if the connection needs it
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
    def execute()
      options = { :parameters => {}, :debug => false, 
                  :http_timeout => 60, :method => :get, 
                  :headers => {}, :redirect_count => 0, 
                  :max_redirects => 10 }.merge(@options)
 
      url = URI(@url)
         
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
      JSON.parse(response.body)
    end 
  end
end
require 'net/http'
require 'json'

module GcalMapper
  #
  # Make a REST get or post request
  #
  class RestRequest

    attr_accessor :url        # Complete url for the request
    attr_accessor :options    # Options for the REST request

    # Initialize a new request
    #
    # @param [String] url the complete url of where to send the request
    # @datarequest.rbparam [Hash] options contain all the options that can be included in REST request
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
    # @return [Hash] a Json parsed hash that contains the body of the response.
    def execute
      options = {
        :parameters => {}, :debug => false,
        :http_timeout => 60, :method => :get,
        :headers => {}, :redirect_count => 0,
        :max_redirects => 10
      }.merge(@options)
      url = URI(@url)

      if proxy
        http = Net::HTTP::Proxy(proxy.host, proxy.port).new(url.host, url.port)
      else
        http = Net::HTTP.new(url.host, url.port)
      end

      if url.scheme == 'https'
        http.use_ssl = true
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
      if !(200..300).include?(response.code.to_i)
        raise GcalMapper::BadHTTPStatus
      end

      JSON.parse(response.body)
    end

  end
end
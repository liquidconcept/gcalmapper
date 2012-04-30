require 'google/api_client'
require 'yaml'

module GcalMapper
  
  #
  # make the authentification with Oauth2 and request data from google calendar.
  #
  class Oauth2
    
    # the object [Google::APIClient] from google-api-client
    attr_accessor :client
    # the object [Google::APIClient::API] from google-api-client
    attr_accessor :service
    
    # intialize client info needed for connection to Oauth2.
    #
    # @param [String] yaml_file path to the yaml file which contains acess token, ...
    def initialize (yaml_file)
      oauth_yaml = YAML.load_file(yaml_file)
      @client = Google::APIClient.new
      @client.authorization.client_id = oauth_yaml["client_id"]
      @client.authorization.client_secret = oauth_yaml["client_secret"]
      @client.authorization.scope = oauth_yaml["scope"]
      @client.authorization.refresh_token = oauth_yaml["refresh_token"]
      @client.authorization.access_token = oauth_yaml["access_token"]

      if @client.authorization.refresh_token && @client.authorization.expired?
        @client.authorization.fetch_access_token!
      end
      
      @service = client.discovered_api('calendar', 'v3')
    end
    
    # Get the calendar list for the connected user.
    #
    # @return [Array] all google calendar data that the user can access.
    def get_calendars_list
      page_token = nil
      result = @client.execute(:api_method => @service.calendar_list.list)
      calendar_list = []
      
      while true
        entries = result.data.items
        entries.each do |e|
          calendar_list.push(e)
        end
        if !(page_token = result.data.next_page_token)
          break
        end
        result = @client.execute(:api_method => @service.calendar_list.list,
                                :parameters => {'pageToken' => page_token})
      end
      calendar_list
    end
  
    # Get all events from specified calendar(s).
    #
    # @param [Array] calendar_id contain the calendar(s) id you want to map
    # @return [Array] all events from given calendar(s) id.
    def get_events_list(calendar_id)
      page_token = nil
      result = @client.execute(
        :api_method => @service.events.list,
        :parameters => {'calendarId' => calendar_id})
      events_list = []
        
      while true
        events = result.data.items
        events.each do |e|
          events_list.push(e)
        end
        if !(page_token = result.data.next_page_token)
          break
        end
        result = @client.execute(:api_method => @service.events.list,
                                 :parameters => {'calendarId' => calendar_id, 'pageToken' => page_token})
      end
      
      events_list
    end
    
  end
end
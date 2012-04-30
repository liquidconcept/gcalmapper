require 'google/api_client'
require 'yaml'

module GcalMapper
  class Oauth2
    
    attr_accessor :client, :service
    
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
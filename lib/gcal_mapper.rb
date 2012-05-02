require 'gcal_mapper/version'
require 'gcal_mapper/authbase'
require 'gcal_mapper/assertion'
require 'gcal_mapper/oauth2'
require 'gcal_mapper/datarequest'
require 'gcal_mapper/authentification'
require 'gcal_mapper/calendar'

#
# A library to map Google Calendar events with an ORM.
#
module GcalMapper
    
    # Get all events from specified calendar(s).
    #
    # @param [Array] calendar_id contain the calendar(s) id you want to map
    # @return [Array] all events from given calendar(s) id.
    def self.fetch_events(calendar_id, file, client_email=nil, password=nil)
      events_list = []
  
      auth = self::Authentification.new(file, client_email, password)
      auth.authenticate
        
      calendar = self::Calendar.new
      calendars_list = calendar.get_calendars_list(auth.access_token)
      if calendars_list.empty?
        raise Exception.new("No acessible calendar")
      end
        
      calendar_id.each do |cal|
        if calendars_list.include?(cal)
          if events_list == []
            events_list = calendar.get_events_list(auth.access_token, cal)
          else
            events_list.push(calendar.get_events_list(auth.access_token, cal))
          end
        else
          raise Exception.new("Can't access specified calendar")
        end
      end
      events_list
    end 
end




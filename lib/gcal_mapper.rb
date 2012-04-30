require 'gcal_mapper/version'
require 'gcal_mapper/assertion'
require 'gcal_mapper/oauth2'

#
# A library to map Google Calendar events with an ORM.
#
module GcalMapper
  
  # contains the authentification mode (Oauth2 or Assertion)
  attr_accessor :auth_mode
  # path to the auth_file (yaml file for Oauth2, p12 key file for Assertion)
  attr_accessor :auth_file
  
  # Intialize some of the constant module.
  #
  # @param [String] auth_file path to your yaml file, or the p12 key
  # @param [string] auth_mode which mode of autentification you want use 
  def self.init (auth_file, auth_mode='Oauth2' )
    @auth_mode = auth_mode
    @auth_file = auth_file
  end
  
  # Get all events from specified calendar(s).
  #
  # @param [Array] calendar_id contain the calendar(s) id you want to map
  # @return [Array] all events from given calendar(s) id.
  def self.fetch_events(calendar_id)
    events_list = calendars_list = calendars_id = []
    
    if @auth_mode == 'Oauth2'
      list = self::Oauth2.new(@auth_file)
      calendars_list = list.get_calendars_list
      calendars_list.each do |cal|
        calendars_id.push(cal.id)
      end     
      
      calendar_id.each do |cal|
        if calendars_id.include?(cal)
          events_list.push(list.get_events_list(cal))
        end
      end
    end
    
    events_list
  end

end




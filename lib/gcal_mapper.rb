require 'gcal_mapper/version'
require 'gcal_mapper/assertion'
require 'gcal_mapper/oauth2'

module GcalMapper
  attr_accessor :auth_mode, :auth_file
  
  def self.init (auth_file, auth_mode='Oauth2' )
    @auth_mode = auth_mode
    @auth_file = auth_file
  end
  
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




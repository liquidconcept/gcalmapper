require 'gcal_mapper/version'
require 'gcal_mapper/rest_request'
require 'gcal_mapper/authentification'
require 'gcal_mapper/calendar'
require 'gcal_mapper/errors'
require 'gcal_mapper/sync'
require 'gcal_mapper/mapper'

#
# A library to map Google Calendar events with an ORM.
#
module GcalMapper
  # Get all events from specified calendar(s).
  #
  # @param [Array] calendar_id contain the calendar(s) id you want to map
  # @param [String] file path to the file that contains credentials
  # @param [String] client_email email from the api_consol (service account only)
  # @param [String] user_email email from the impersonated user (service account only)
  # @param [String] password p12 key password (service account only)
  # @return [Array] all events from given calendar(s) id.
  def self.fetch_events(calendar_id, file, client_email=nil, user_email=nil, password=nil)
    events_list = []

    auth = self::Authentification.new(file, client_email, user_email, password)
    auth.authenticate

    calendar = self::Calendar.new
    calendars_list = calendar.get_calendars_list(auth.access_token)
    if calendars_list.empty?
      raise GcalMapper::CalendarAvailabilityError
    end

    calendar_id.each do |cal|
      if calendars_list.include?(cal)
        if events_list == []
          events_list = calendar.get_events_list(auth.access_token, cal)
        else
          events_list.push(calendar.get_events_list(auth.access_token, cal))
        end
      else
        raise GcalMapper::CalendarAccessibilityError
      end
    end

    events_list
  end

end

module GcalMapper
  #
  # Provide methods to get google calendar data
  #
  class Calendar

    # Get the calendar list for the connected user.
    #
    # @param [Hash] access_token the token obtain with Authentification.access_token
    # @return [Array] google calendar id that the user can access.
    def get_calendars_list(access_token)
      url = 'https://www.googleapis.com/calendar/v3/users/me/calendarList'
      options = {
        :method => :get,
        :headers => {'Authorization' => 'Bearer ' + access_token}
      }
      req = GcalMapper::RestRequest.new(url, options)
      response = req.execute

      tab_cal=response['items']
      ids = []

      tab_cal.each do |t|
        t.each do |k, v|
          if k == 'id'
            ids.push(v)
          end
        end
      end

      ids
    end

    # Get all events from specified calendar(s).
    #
    # @param [Hash] access_token the token obtain with Authentification.access_token
    # @param [Array] calendar_id contain the calendar(s) id you want to map
    # @return [Array] all events from given calendar(s) id.
    def get_events_list(access_token, calendar_id)
      url = 'https://www.googleapis.com/calendar/v3/calendars/'+calendar_id+'/events?showDeleted=true'
      options = {
        :method => :get,
        :headers => {'Authorization' => 'Bearer ' + access_token},
      }
      req = GcalMapper::RestRequest.new(url, options)
      response = req.execute
      response['items']
    end

  end
end
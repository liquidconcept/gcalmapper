require 'active_record'

module GcalMapper

  #
  # Provide methods to synch google calendar and local bd
  #
  class Sync

    # proxy to call sync methods and set new instance
    #
    # @param [Configuration] config configuration class seted by DSL
    # @param [Class] base class of the caller
    def self.sync(config, base)
      new(config, base).sync_gcal
    end

    # new Sync object
    #
    # @param [Configuration] config configuration class seted by DSL
    # @param [Class] base class of the calle
    def initialize(config, base)
      @config = config
      @base = base
    end

    # full synchronization step by step
    #
    def sync_gcal
      authenticate
      fetch_events
      save_events
    end

    private
    # call Authentification class to authenticate the API
    #
    def authenticate
      @auth = GcalMapper::Authentification.new(@config.file, @config.client_email, @config.user_email, @config.password)
      @auth.authenticate
    end

    # Get all events from specified calendar(s).
    #
    # @return [Array] all events from given calendar(s) id.
    def fetch_events
      events_list = []

      calendar = GcalMapper::Calendar.new
      calendars_list = calendar.get_calendars_list(@auth.access_token)
      if calendars_list.empty?
        raise GcalMapper::CalendarAvailabilityError
      end

      @config.calendars.each do |cal|
        if calendars_list.include?(cal)
          if events_list == []
            events_list = calendar.get_events_list(@auth.access_token, cal)
          else
            events_list.push(calendar.get_events_list(@auth.access_token, cal))
          end
        else
          raise GcalMapper::CalendarAccessibilityError
        end
      end

      @events_list = events_list
    end

    # Get all events from specified calendar(s). an keep synchronize with the online gcal
    #
    def save_events
      current_list = @base.all

      @events_list.each do |event|
        event_exist = false

        current_list.each do |current|

          if current.send(@config.gid) == event['id']
            event_exist = true
            if event['status'] == 'cancelled'
              current.destroy
            else
              if current.updated_at != event['updated']
                set_attrib(current, event)
                current.save
              end
            end

            break
          end
        end

        if !event_exist && event['status'] != 'cancelled'
          obj = @base.new
          obj.send(@config.gid + '=', event['id'])
          set_attrib(obj, event)
          obj.save
        end
      end
    end

    # set the object from fields configuration
    #
    # @param [Object] obj instancied obj to set
    # @param [Hash] event event to save in obj
    def set_attrib(obj, event)
      @config.fields.each do |field, source|
        if source[:source].include?('.')
          data = source[:source].split('.')
          obj.send(field + '=', event[data[0]][data[1]])
        else
          obj.send(field + '=', event[source[:source]])
        end
      end
    end

  end
end

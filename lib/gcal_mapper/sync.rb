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
      retried = false
      begin
        calendars_list = calendar.get_calendars_list(@auth.access_token)
      rescue
        if !retried
          @auth.refresh_token
          retried = true
          retry
        else
          raise
        end
      end

      if calendars_list.empty?
        raise GcalMapper::CalendarAvailabilityError
      end

      @config.calendars.each do |cal|
        events_list = []
        if calendars_list.include?(cal)
          retried = false
          begin
            events_list += (calendar.get_events_list(@auth.access_token, cal))
          rescue
            if !retried
              @auth.refresh_token
              retried = true
              retry
            else
              raise
            end
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
      adapter = Mapper.adapter

      @events_list.each do |event|

        existed_event = adapter.find_by(@config.gid, event['id'])
        event_exist = !existed_event.nil?

        if event_exist
          if event['status'] == 'cancelled'
            adapter.delete!(existed_event.id)
          else
            updated_attrib = set_attrib(event)
            current_attrib = existed_event.attributes
            current_attrib.delete('id')
            if current_attrib != updated_attrib
              adapter.update!(existed_event.id, updated_attrib)
            end
          end
        end

        if !event_exist && event['status'] != 'cancelled'
          adapter.create!(set_attrib(event))
        end
      end
    end

    # set the object from fields configuration
    #
    # @param [Hash] event event to save in obj
    # @return [hash] hash of setted attributes
    def set_attrib(event)
      attrib_hash = {@config.gid => event['id']}
      @config.fields.each do |field, source|
        if source[:source].include?('.')
          data = source[:source].split('.')
          attrib_hash[field] = eval_value(source, event[data[0]][data[1]])
        else
          attrib_hash[field] = eval_value(source, event[source[:source]])
        end
        if (attrib_hash[field].nil? && source.has_key?(:if_empty))
          if source[:if_empty].include?('.')
            data = source[:if_empty].split('.')
            attrib_hash[field] = eval_value(source, event[data[0]][data[1]])
          else
            attrib_hash[field] = eval_value(source, event[source[:if_empty]])
          end
        end
      end

      attrib_hash
    end

    # eval the value from the source options
    #
    # @param [Hash] source source of the field
    # @param [string] raw_data the string extract form google event data
    # @return the data asked
    def eval_value(source, raw_data)
      if source[:match]
        data = source[:match].match(raw_data).to_s
        data = source[:default] if data == ''
      else
        data = raw_data
      end

      data
    end

  end
end

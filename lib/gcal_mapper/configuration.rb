module GcalMapper
  #
  # Gem's configuration
  #
  class Configuration

    attr_accessor :gid          # name of the field that contains google event id
    attr_accessor :fields       # hash that contains all the field with their source config
    attr_accessor :calendars    # array that contains all the calendar id to fetch
    attr_accessor :file         # Auth file path
    attr_accessor :client_email # Service account email
    attr_accessor :user_email   # email of user to impersonat
    attr_accessor :password     # passowrd for p12 key

    # New configuration object
    #
    def initialize
      @fields = {}
      @calendars = []
    end

  end
end
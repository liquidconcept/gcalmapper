module GcalMapper
  module Mapper
    #
    # Provide DSL to configure gem
    #
    class DSL

      # Intitialize config
      #
      def initialize(config)
        @config = config
      end

      # Add new calendar id
      #
      # @param [string] id calendar id to add
      def calendar (id)
        @config.calendars.push(id)
      end

      # Add a new field
      #
      # @param [String] name DB field name
      # @param [Hash] options contains source options used to fill the field
      def field(name, options = {})
        @config.fields.merge!(name => options)
      end

      # Add authentification configuration
      #
      # @param [Hash] options contains the stuff to configure authetification
      def configure(options = {})
        @config.file = options[:file]
        @config.client_email = options[:client_email]
        @config.user_email = options[:user_email]
        @config.password = options[:password]
      end

      # Give the field in DB that is reserved to put event id given by google
      #
      # @param [String] name DB field name
      def google_id(name)
        @config.gid = name
      end

    end
  end
end
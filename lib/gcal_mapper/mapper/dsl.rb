module GcalMapper
  module Mapper
    #
    # Provide DSL to configure gem
    #
    class DSL
      VALID_FIELD_OPTIONS = [:source, :match, :default]

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
        raise GcalMapper::DSLSyntaxError, 'Source option must be present' if !options.include?(:source)
        raise GcalMapper::DSLSyntaxError, 'field option not available' if options.keys != VALID_FIELD_OPTIONS & options.keys

        if options[:match]
          raise GcalMapper::DSLSyntaxError, 'invalid regex' if options[:match].class != Regexp
        end

        @config.fields.merge!(name => options)
      end

      # Add authentification configuration
      #
      # @param [Hash] options contains the stuff to configure authetification
      def configure(options = {})
        raise GcalMapper::DSLSyntaxError, 'you must give a credential file' if options[:file].nil?
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
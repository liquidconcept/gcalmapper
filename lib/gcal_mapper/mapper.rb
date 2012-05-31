require 'gcal_mapper/mapper/dsl'
require 'gcal_mapper/mapper/active_record'
require 'gcal_mapper/mapper/simple'

module GcalMapper
  #
  # Provide dsl en sync methods
  #
  module Mapper

    # setter for class varaible base
    #
    # @return [Class] class name of the includer
    def self.base=(base)
      @@base = base
    end

    # reader for class varaible base
    #
    # @return [Class] class name of the includer
    def self.base
      @@base
    end

    # setter for config class attributes
    #
    # @param [Configuration] config configuration class
    def self.config=(config)
      @@config = config
    end

    # getter for config class attributes
    #
    # @return [Configuration] configuration class
    def self.config
      @@config
    end

    # setter for adapter class attributes
    #
    # @param [Configuration] config configuration class
    def self.adapter=(adapter)
      @@adapter = adapter
    end

    # getter for adapter class attributes
    #
    # @return [Configuration] configuration class
    def self.adapter
      @@adapter
    end

    #
    # module to add class methods to the includer
    #
    module ClassMethods

      # provide dsl function
      #
      # @param [Block] block contain dsl of th caller
      def calendar(&block)
        Mapper.config = GcalMapper::Configuration.new
        dsl = DSL.new(Mapper.config)
        dsl.instance_eval(&block)
      end

      # synchronize methods for the caller
      #
      def synchronize_calendar
        Sync.sync(Mapper.config, Mapper.base)
      end

    end

  end
end
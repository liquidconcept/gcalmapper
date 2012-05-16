require 'gcal_mapper/mapper/dsl'

module GcalMapper
  #
  # Provide dsl en sync methods
  #
  module Mapper

    # execute when the file is included
    #
    # @param [Class] base class of the includer
    def self.included(base)
      base.extend(ClassMethods)
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
      @@config=config
    end

    # getter for config class attributes
    #
    # @return [Configuration] configuration class
    def self.config
      @@config
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
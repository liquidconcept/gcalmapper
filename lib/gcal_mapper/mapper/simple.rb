module GcalMapper
  module Mapper
    #
    # module to include when no orm is used
    #
    module Simple

      # execute when the file is included
      #
      # @param [Class] base class of the includer
      def self.included(base)
        base.extend(GcalMapper::Mapper::ClassMethods)
        Mapper.base = base
        Mapper.adapter = Simple.new(base)
      end

      #
      # Adapter to use without an orm
      #
      class Simple
        attr_reader :events # array of the synchronized events

        # new object
        #
        # @param [class] klass class that need an adapter
        def initialize(base)
          @base = base
          @events = []
        end

        # create and save object using attributes
        #
        # @param [Hash] attributes all the attributes to save in the new object
        def create!(attributes)
          obj = @base.new
          obj.id = @events.count
          attributes.each do |key, value|
            obj.send(key+'=', value)
          end

          @events << obj
        end

        # update an object
        #
        # @param [Int] id id of the object in the DB
        # @param [Hash] attributes hash containing the field to update
        def update!(id, attributes)
          obj = @events[id]
          attributes.each do |key, value|
            obj.send(key+'=', value)
          end

          @events << obj
        end

        # delet an object
        #
        # @param [Int] id id of the object in the DB
        def delete!(id)
          @events[id] = nil

          @events.each_with_index do |item, index|
            if item
              if @events[index + 1]
                item = @events[index + 1]
                item.id =- 1
              end
            end
          end

          @events.delete(nil)
        end

        # Find all models
        #
        def find_all
          @events
        end

        # find an object from a field and a value
        #
        # @param [String] field name of the field where to search
        # @param [String] value the value to find
        def find_by(field, value)
          find_event = nil
          @events.each do |event|
            find_event = event if event.send(field) == value
          end

          find_event
        end

      end
    end
  end
end
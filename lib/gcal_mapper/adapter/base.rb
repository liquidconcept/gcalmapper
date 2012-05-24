module GcalMapper
  module Adapter
    class Base
      attr_reader :klass

      # Your ORM adapter needs to inherit from this Base class and its adapter
      # will be registered.
      def self.inherited(adapter)
        Adapter.adapters << adapter
        super
      end

      def initialize(klass)
        @klass = klass
      end

      # Create and save object using attributes
      def create!(attributes)
        raise NotImplementedError
      end

      def update!(id, attributes)
        raise NotImplementedError
      end

      def delete!(id)
        raise NotImplementedError
      end

      # Find all models
      def find_all
        raise NotImplementedError
      end

      def find_by_google_id(field, google_id)
        raise NotImplementedError
      end

    end
  end
end
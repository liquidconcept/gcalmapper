module GcalMapper
  module Adapter
    #
    # Module to find the right adapter for a calss
    #
    module ToAdapter

      # find and create the right adapter for a class
      #
      # @return [Adapter] the instancied adapter class
      def to_adapter
        @_to_adapter ||= self::Adapter.new(self)
      end

    end
  end
end
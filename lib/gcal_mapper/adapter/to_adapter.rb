module GcalMapper
  module Adapter
    module ToAdapter
      def to_adapter
        @_to_adapter ||= self::Adapter.new(self)
      end
    end
  end
end
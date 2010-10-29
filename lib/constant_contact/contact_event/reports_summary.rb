module ConstantContact
  module ContactEvent
    class ReportsSummary < ContactEventBase
      def self.collection_name
        'summary'
      end
    end
  end
end
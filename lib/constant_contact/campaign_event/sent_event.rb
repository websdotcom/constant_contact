module ConstantContact
  module CampaignEvent
    class SentEvent < CampaignEventBase
      def self.collection_name
       'sends'
      end
    end
  end
end
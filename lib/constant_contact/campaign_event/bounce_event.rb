module ConstantContact
  module CampaignEvent
    class BounceEvent < CampaignEventBase
     def self.collection_name
       'bounces'
     end
    end
  end
end
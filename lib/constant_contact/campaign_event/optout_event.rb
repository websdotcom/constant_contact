module ConstantContact
  module CampaignEvent
    class OptoutEvent < CampaignEventBase
     def self.collection_name
       'optouts'
     end
    end
  end
end
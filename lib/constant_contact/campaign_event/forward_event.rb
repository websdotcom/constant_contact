module ConstantContact
  module CampaignEvent
    class ForwardEvent < CampaignEventBase
     def self.collection_name
       'forwards'
     end
    end
  end
end
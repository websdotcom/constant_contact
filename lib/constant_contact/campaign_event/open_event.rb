module ConstantContact
  module CampaignEvent
    class OpenEvent < CampaignEventBase
     def self.collection_name
       'opens'
     end
    end
  end
end
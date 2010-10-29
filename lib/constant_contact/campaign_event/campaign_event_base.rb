module ConstantContact
  module CampaignEvent
    class CampaignEventBase < Base
      self.site += "/campaigns/:campaign_id/events"
    end
  end
end
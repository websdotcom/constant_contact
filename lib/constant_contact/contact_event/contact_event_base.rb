module ConstantContact
  module ContactEvent
    class ContactEventBase < Base
      self.site += "/contacts/:contact_id/events"
    end
  end
end
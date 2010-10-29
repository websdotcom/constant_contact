module ConstantContact
  module ContactEvent
   class SentEvent < ContactEventBase
     def self.collection_name
       'sends'
     end
   end
  end
end
module ConstantContact
  class CampaignSchedule < Base
    attr_accessor :campaign_id

    self.prefix = "/campaigns/:campaign_id/"

    def initialize(*args)
      obj = super
      obj
    end
    
    def self.collection_name
      'schedules'
    end
    
    def to_xml
      xml = Builder::XmlMarkup.new
      xml.tag!('Schedule', :xmlns => 'http://ws.constantcontact.com/ns/1.0/', :id => schedule_url) do
        self.attributes.reject {|k,v| k.to_s.camelize == 'CampaignId'}.each{|k, v| xml.tag!( k.to_s.camelize, v )}
      end
    end
    
    def campaign_url
      'http://api.constantcontact.com/ws/customers/' + self.class.user + '/campaigns/' + self.prefix_options[:campaign_id].to_s
    end
    
    def schedule_url
      campaign_url + '/schedules/1'
    end
  end
end

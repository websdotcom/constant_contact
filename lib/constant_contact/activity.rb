
module ConstantContact
  class Activity < Base
    self.format = ActiveResource::Formats::HtmlEncodedFormat
    attr_accessor :contacts, :lists, :activity_type

    def self.parse_id(url)
      url.to_s.split('/').last
    end

    def self.element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      id_val = parse_id(id)
      id_val = id_val.blank? ? nil : "/#{id_val}"
      "#{collection_path}#{id_val}#{query_string(query_options)}"
    end

    def encode
      post_data = "activityType=#{self.activity_type}"
      post_data += self.encoded_data
      post_data += self.encoded_lists
      return post_data
    end

    def activity_type
      @activity_type ||= "SV_ADD"
    end
    
    protected
    def encoded_data
      result = "&data="
      result += CGI.escape("Email Address,First Name,Last Name\n")
      contact_strings = []
      self.contacts.each do |contact|
        contact_strings << "#{contact.email_address}, #{contact.first_name}, #{contact.last_name}"        
      end      
      result += CGI.escape(contact_strings.join("\n"))        
      return result
    end
    
    
    def encoded_lists
      result = ""
      self.lists.each do |list|
        result += "&lists="
        result += CGI.escape(list.id)
      end
      return result
    end
    
  end
end
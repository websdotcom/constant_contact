# Value limits: http://constantcontact.custhelp.com/cgi-bin/constantcontact.cfg/php/enduser/std_adp.php?p_faqid=2217
module ConstantContact
  class Contact < Base
    attr_accessor :opt_in_source
    
    # NOTE: All column names are available only when finding a contact by id.
    # @@column_names = [ :addr1, :addr2, :addr3, :city, :company_name, :country_code, :country_name, 
    #                       :custom_field1, :custom_field10, :custom_field11, :custom_field12, :custom_field13, 
    #                       :custom_field14, :custom_field15, :custom_field2, :custom_field3, :custom_field4, :custom_field5, 
    #                       :custom_field6, :custom_field7, :custom_field8, :custom_field9, :email_address, :email_type, 
    #                       :first_name, :home_phone, :insert_time, :job_title, :last_name, :last_update_time, :name, :note, 
    #                       :postal_code, :state_code, :state_name, :status, :sub_postal_code, :work_phone ]
    
    def to_xml
      xml = Builder::XmlMarkup.new
      xml.tag!("Contact", :xmlns => "http://ws.constantcontact.com/ns/1.0/") do
        self.attributes.reject {|k,v| k == 'ContactLists'}.each{|k, v| xml.tag!( k.to_s.camelize, v )}
        xml.tag!("OptInSource", self.opt_in_source)
        xml.tag!("ContactLists") do
          @contact_lists = [1] if @contact_lists.nil? && self.new?
          self.contact_lists.sort.each do |list_id|
            xml.tag!("ContactList", :id=> self.list_url(list_id))
          end
        end
      end
    end
    
    def opt_in_source
      @opt_in_source ||= "ACTION_BY_CUSTOMER"
    end
    
    # see http://developer.constantcontact.com/doc/manageContacts#create_contact for more info about the two values.
    def opt_in_source=(val)
      @opt_in_source = val if ['ACTION_BY_CONTACT','ACTION_BY_CUSTOMER'].include?(val)
    end
    
    def list_url(id=nil)
      id ||= defined?(self.list_id) ? self.list_id : 1
      "http://api.constantcontact.com/ws/customers/#{self.class.user}/lists/#{id}"
    end
    
    # Can we email them?
    def active?
      status.downcase == 'active'
    end
    
    def contact_lists
      return @contact_lists if defined?(@contact_lists)
      # otherwise, attempt to assign it
      @contact_lists = if self.attributes.keys.include?('ContactLists')
        if self.ContactLists
          if self.ContactLists.ContactList.is_a?(Array)
            self.ContactLists.ContactList.collect { |list|
              ConstantContact::Base.parse_id(list.id)
            }
          else
            [ ConstantContact::Base.parse_id(self.ContactLists.ContactList.id) ]
          end
        else
          [] # => Contact is not a member of any lists (legitimatly empty!)
        end
      else
        nil
      end
    end
    
    def contact_lists=(val)
      @contact_lists = val.kind_of?(Array) ? val : [val]
    end
    
    def self.find_by_email(email_address)
      find :first, {:params => {:email => email_address.downcase}}
    end
    
    protected
    def validate
      # errors.add(:opt_in_source, 'must be either ACTION_BY_CONTACT or ACTION_BY_CUSTOMER') unless ['ACTION_BY_CONTACT','ACTION_BY_CUSTOMER'].include?(attributes['OptInSource'])
      # errors.add(:email_address, 'cannot be blank') unless attributes.has_key?('EmailAddress')
    end
    
  end
end
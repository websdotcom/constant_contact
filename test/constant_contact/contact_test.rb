require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  
  context 'class' do
    setup do 
      ConstantContact::Base.user = "jonsflowers"
      @contact = ConstantContact::Contact.new(:email_address => "jon@example.com",
                             :first_name => "jon",
                             :last_name => "smith")
    end
    
    should 'respond to encode' do
      assert_respond_to ConstantContact::Contact.new, :encode
    end
    
    should 'call to_xml' do
      @contact.expects(:to_xml)
      @contact.encode
    end
  end
  
  context 'setting accessible attributes' do
    setup do
      ConstantContact::Base.user = "jonsflowers"
      @contact = ConstantContact::Contact.new(:email_address => "jon@example.com",
                             :first_name => "jon",
                             :last_name => "smith")
    end
    
    should 'returns nil when contact list has not been set' do
      assert_equal nil, @contact.contact_lists
    end
    should 'permit assigning ids to the contact list' do
      @contact.contact_lists = [1,2]
      assert_equal [1,2], @contact.contact_lists
    end
  end
  
  context 'to_xml' do
    setup do 
      ConstantContact::Base.user = "jonsflowers"
      @contact = ConstantContact::Contact.new(:email_address => "jon@example.com",
                             :first_name => "jon",
                             :last_name => "smith")
    end
        
    should 'have contact tag' do
      assert_match /<Contact xmlns=\"http:\/\/ws.constantcontact.com\/ns\/1.0\/\"/, @contact.to_xml
      assert_match /\<\/Contact\>/, @contact.to_xml
    end
    
    should 'have first_name' do
      assert_match /<FirstName>/, @contact.to_xml
    end
    
    should 'list selected by default' do
      assert_match /http:\/\/api.constantcontact.com\/ws\/customers\/jonsflowers\/lists\/1/, @contact.to_xml
    end
    
    should 'provide opt in select by default' do
      assert_match /ACTION_BY_CUSTOMER/, @contact.to_xml
    end
    
    should 'include the default contact list when no lists are specified' do
      assert_match /<ContactList id="/, @contact.to_xml
    end
    
    should 'include all contact lists configured' do
      @contact.contact_lists = [1,2]
      assert_equal [1,2], @contact.contact_lists
      xml = @contact.to_xml
      assert_equal 2, xml.scan(/<ContactList /).length, xml
      assert_match /<ContactList id="#{Regexp.escape(@contact.list_url(1))}"/, xml
      assert_match /<ContactList id="#{Regexp.escape(@contact.list_url(2))}"/, xml
    end
  end
  
  context "find with query parameters" do
    setup do 
      ConstantContact::Base.user = "joesflowers"
      ConstantContact::Base.password = "password"
      ConstantContact::Base.api_key = "api_key"
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/contacts/2', 'single_contact_by_id.xml')
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/contacts/3', 'single_contact_by_id_with_no_contactlists.xml')
    end
    
    should 'find contact with given id' do
       assert_equal 'jon smith', ConstantContact::Contact.find(2).Name
    end
    
    should 'return an array of lists they are a member of' do
      c = ConstantContact::Contact.find(2)
      assert_equal [1], c.contact_lists
    end
    should 'return an empty array when no contact lists are present' do
      c = ConstantContact::Contact.find(3)
      assert_equal [], c.contact_lists
    end
    
  end
  
  context "find with email in query parameters" do
    setup do 
      ConstantContact::Base.user = "joesflowers"
      ConstantContact::Base.password = "password"
      ConstantContact::Base.api_key = "api_key"
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/contacts', 'all_contacts.xml')
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/contacts?email=jon%40example.com', 'single_contact_by_email.xml')
    end
    
    should 'find contact with email address' do
       assert_equal 'smith, jon', ConstantContact::Contact.find(:first, :params => {:email => 'jon@example.com'}).Name
    end
    
    should 'return nil when asking for contact_lists' do
      assert_equal nil, ConstantContact::Contact.find(:first, :params => {:email => 'jon@example.com'}).contact_lists
    end
    
  end
  
  context 'list url' do
    setup do
      ConstantContact::Base.user = "joesflowers"
    end
    should 'apply the default id (1) to a new contact' do
      c = ConstantContact::Contact.new(:email_address => "jon@example.com",
                             :first_name => "jon",
                             :last_name => "smith")
      assert_equal 'http://api.constantcontact.com/ws/customers/joesflowers/lists/1', c.list_url
      assert_equal 'http://api.constantcontact.com/ws/customers/joesflowers/lists/2', c.list_url(2)
    end
  end
  
end

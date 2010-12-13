require File.dirname(__FILE__) + '/../test_helper'

class Activity < Test::Unit::TestCase
  
  context 'encode' do
    context 'with raw data' do
      setup do
        @data = "Email Address,Custom Field1\nemail1@domain.com,custom1\nemail2@domain.com,custom2"
        @list = ConstantContact::List.new
        @list.stubs(:id).returns('http://api.constantcontact.com/ws/customers/freerobby/lists/3')
        @activity = ConstantContact::Activity.new(
          :activity_type => "SV_ADD"
        )
        @activity.raw_data = @data
        @activity.lists = [@list]
      end
      should 'use raw data, bypassing contact parsing' do
        assert_match(CGI.escape(@data), @activity.encode)
      end
      should 'include activity type' do
        assert_match('activityType=SV_ADD', @activity.encode)
      end
      should 'include list' do
        assert_match(CGI.escape(@list.id), @activity.encode)
      end
    end
    context 'with contact data' do
      setup do 
        @contacts = []
        3.times do |n|
          @contacts << ConstantContact::Contact.new(:first_name => "Fred#{n}",
                                                    :last_name => "Test#{n}",
                                                    :email_address => "email#{n}@gmail.com")
        end        
        @activity = ConstantContact::Activity.new(:activity_type => "SV_ADD")
        @activity.contacts = @contacts
        @list = ConstantContact::List.new
        @list.stubs(:id).returns('http://api.constantcontact.com/ws/customers/joesflowers/lists/2')
        @activity.lists = [@list]
      end

      should 'include activity type' do
        assert_match(/activityType=SV_ADD/, @activity.encode)
      end

      should 'include contacts data' do
        assert_match(/\&data\=Email\+Address\%2CFirst\+Name\%2CLast\+Name\%0A/, @activity.encode)
        assert_match(/email0\%40gmail\.com\%2C\+Fred0\%2C\+Test0\%0A/, @activity.encode)
      end

      should 'include lists' do
        assert_match(/Test2\&lists\=http\%3A\%2F\%2Fapi\.constantcontact\.com\%2Fws\%2Fcustomers\%2Fjoesflowers\%2Flists\%2F2/, @activity.encode)
      end
    end
  end
  
  context 'format' do 
    should 'be html encoded' do 
      assert_equal ActiveResource::Formats[:html_encoded], ConstantContact::Activity.connection.format
    end
  end
  
end
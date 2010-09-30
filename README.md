ConstantContact
===============
This is a very ActiveResource-like ruby wrapper to the Constant Contact API.  It's not quite done yet and if you are interested in using this code, check it out, and message me with questions. 

See the [ActiveResource::Base docs](http://api.rubyonrails.org/classes/ActiveResource/Base.html) for more information on how to use this ActiveResource-based wrapper.

Examples
--------

All examples require setting up either the specific class you'll be use or the Base object before use:

    ConstantContact::Base.user = 'user'
    ConstantContact::Base.api_key = 'api-key'
    ConstantContact::Base.password = 'password'


### Find Lists

    ConstantContact::List.find(1)
    ConstantContact::List.find :all

### Find A Contact


    ConstantContact::Contact.find(1)
    ConstantContact::Contact.find(:first, :params => {:email => 'jon@example.com'})
    ConstantContact::Contact.find_by_email('jon@example.com') # => same as previous line

### Create a Contact (with rescue if it already exists)

    ConstantContact::Base.user = 'user'
    ConstantContact::Base.api_key = 'api-key'
    ConstantContact::Base.password = 'password'

    # Contact not found. Create it.
    begin
      @contact = ConstantContact::Contact.new(
        :email_address => "jon@example.com",
        :first_name => "jon",
        :last_name => "smith"
      )
      @contact.save
    rescue ActiveResource::ResourceConflict => e
      # contact already exists
      puts 'Contact already exists. Saving contact failed.'
      puts e
    end

### Find a Contact By Email Address, Check if They're a Member of the Default List

    c = ConstantContact::Contact.find_by_email('jon@example.com')
    @contact = ConstantContact::Contact.find(c.int_id) # Because Constant Contact doesn't return a full contact when searching by email
    puts 'In default contact list.' if @contact.contact_lists.include?(1) # contact_lists is an array of list ids


Copyright (c) 2009 Timothy Case, released under the MIT license

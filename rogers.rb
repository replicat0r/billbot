require 'rubygems'
require 'watir-webdriver'
require 'headless'

login_cred = {
    'user' => 'lukeyong15',
    'pass' => 'Iverson03'
}
login_field_names = {
    'user' => 'USER',
    'pass' => 'password'
}

login_url = "https://www.rogers.com/web/totes/#/signin"

# headless = Headless.new
# headless.start

browser = Watir::Browser.new 
browser.goto(login_url)
browser.text_field(name: login_field_names['user']).set login_cred['user']
browser.text_field(name: login_field_names['pass']).set login_cred['pass']
browser.button(class: 'cta-round').click

# if ((browser.select(:id => 'accountType').exists? && browser.select(:id => 'accountType').options.length > 1) || !browser.select(:id => 'accountType').exists?)
#     puts 'exists'
#     Watir::Wait.until {browser.h3(text: /Which account would you like to view today?/).exists?}
#     browser.ul(:class => "list-of-accounts").lis.each {|account|
#         if (account.div(:class => /warning/).present? == false)
#             account.click
#             break
#         end
#         puts 'warning'
#     }
# end
 
browser.goto('https://www.rogers.com/web/totes/#/viewbill')
Watir::Wait.until {browser.iframe.div(:class => /summary-bar/).exists?}
# puts browser.iframe.div(:class => /summary-bar/).text
puts browser.iframe.div(:class => /due_holder/).text

# browser.close
# headless.destroy


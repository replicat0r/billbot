require 'rubygems'
require 'watir-webdriver'
require 'headless'

login_cred = {
    'user' => "julius_tang@hotmail.com",
    'pass' => "bodybuilding88"
}
login_field_names = {
    'user' => 'ctl00$BodyContent$ctrlLogin1$login$UserName',
    'pass' => 'ctl00$BodyContent$ctrlLogin1$login$Password'
}

login_url = "https://www.enbridgegas.com/myEnbridge/login.aspx"

headless = Headless.new
headless.start

browser = Watir::Browser.new 
browser.goto(login_url)
browser.text_field(name: login_field_names['user']).set login_cred['user']
browser.text_field(name: login_field_names['pass']).set login_cred['pass']
browser.link(id: 'ctl00_BodyContent_ctrlLogin1_login_lnkbtnLogin').click
puts browser.title
puts "Balance: " + browser.tds(:class => 'summaryinfo')[1].text 
puts "Due Date: " + browser.tds(:class => 'summaryinfo')[0].text

browser.a(:text => 'Payments').click
browser.a(:text => 'Payment History').click
browser.a(:text => 'SUBMIT').click
Watir::Wait.until {browser.iframe.table(:id => "rgrdPaymentHistory_ctl00").exists?}
csv_data = "Amount,Date\n"
browser.iframe.table(:id => "rgrdPaymentHistory_ctl00").trs.each{|x|
    csv_data = csv_data + x.tds[2].text + "," + x.tds[1].text + "\n"
}
puts csv_data
browser.close
headless.destroy


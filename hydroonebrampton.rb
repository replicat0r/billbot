require 'rubygems'
require 'watir-webdriver'
require 'headless'

login_cred = {
    'user' => "luke.yong15@gmail.com",
    'pass' => "hello2015"
}
login_url = "https://customerservice.hydroonebrampton.com/app/login.jsp"


headless = Headless.new
headless.start
browser = Watir::Browser.new
browser.goto(login_url)
browser.text_field(name: 'accessCode').set login_cred['user']
browser.text_field(name: 'password').set login_cred['pass']
browser.button(:text => /Login/).click
browser.button(:text => /most current eBill/).click
browser.tds(:css => 'td.hidden-xs')[1..3].each{|x| puts x.text}
browser.goto('https://secure6.i-doxs.net/HydroOneBrampton/Secure/Bills.aspx')
index = 0
csv_data = "Amount Due,Due Date\n"
browser.tds(:css => 'td.hidden-xs:nth-child(5)').each{|x|
    csv_data = csv_data + x.text + "," + browser.tds(:css => 'td.hidden-xs:nth-child(6)')[index].text + "\n"
    index = index+1;
}
puts csv_data
browser.close
headless.destroy
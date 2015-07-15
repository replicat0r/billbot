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

if browser.h4(:text => /Welcome to myHOB Dashboard/).exists?  && browser.div(:text => /Having difficulty finding your ePayment information?/).exists?


  browser.button(:text => /most current eBill/).click

  puts 'Account number: ' + browser.tds(:css => 'td.hidden-xs')[1].text
  puts 'Account Balance: $' + browser.tds(:css => 'td.hidden-xs')[2].text
  puts 'Due Date: ' + browser.tds(:css => 'td.hidden-xs')[3].text

  browser.goto('https://secure6.i-doxs.net/HydroOneBrampton/Secure/Bills.aspx')
  index = 0
  data = []
  browser.tds(:css => 'td.hidden-xs:nth-child(5)').each do |x|
    amount = x.text
    date = browser.tds(:css => 'td.hidden-xs:nth-child(6)')[index].text
    data[index] = {:due_date_full => date, :amount => amount, :date_month => date}
    index += 1;
  end
  puts data
  browser.close
  headless.destroy
  puts true
else
  puts false
end

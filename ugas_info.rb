require 'rubygems'
require 'mechanize'
require 'nokogiri'


login_cred = {'user' => "j2mcorp",'pass' => "bridgeport13"}
login_field_names = {'user' => 'loginFrameUserIDTextBox','pass' => 'loginFramePasswordTextBox'}


mech = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.log = Logger.new "mech.log"

}

mech.get('https://myaccount.uniongas.com/login.aspx')
form = mech.page.form_with(:action=>/login.aspx/) 
form[login_field_names['user']] = login_cred['user']
form[login_field_names['pass']] = login_cred['pass']
form.submit(form.button_with(:type=>'submit'))
# puts mech.page.parser.css("title").text.strip 


puts "Current balance: " + mech.page.parser.css("#body_content_currentAccountStatus_CurrentBalance_Data").text.strip
puts "Due Date: " + mech.page.parser.css("#body_content_mostRecentBillSummary_AppOrLatePaymentDate_Data").text.strip


mech.get('https://myaccount.uniongas.com/billHistory.aspx')
# File.open('file.html', 'w'){|f| f.puts mech.page.parser.to_html} 
# bills = Nokogiri::HTML(open('file.html')) 
counter = 0
csv_data = ""
mech.page.parser.css('div.billHistoryLiteralContentCellColumn0LabelRegion a').each do |bill|
    csv_data = csv_data + bill.text.strip + "," + mech.page.parser.css('div.billHistoryLiteralContentCellColumn8LabelRegion')[counter].text.strip + "\n"
    counter = counter + 1
end
puts csv_data
# File.open('billhistory.csv', 'w'){|f| f.puts csv_data}
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'logger'


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
puts mech.page.parser.css("title").text.strip

mech.get('https://myaccount.uniongas.com/billHistory.aspx')
# File.open('file.html', 'w'){|f| f.puts mech.page.parser.to_html}
# bills = Nokogiri::HTML(open('file.html'))
# bills.css('div.billHistoryLiteralContentCellColumn0LabelRegion a').each do |bill|
#   puts "https://myaccount.uniongas.com/#{bill['href']}"
#   mech.pluggable_parser.pdf = Mechanize::FileSaver
#   mech.get("https://myaccount.uniongas.com/#{bill['href']}")
# end

index = 0
data = []
mech.page.parser.css('div.billHistoryLiteralContentCellColumn0LabelRegion a').each do |bill|
    due_date = bill.text.strip
    due_month = Integer(bill.text.strip.gsub!('/',''))
    amount_due = mech.page.parser.css('div.billHistoryLiteralContentCellColumn8LabelRegion')[index].text.strip
    data[index] = {:due => due_date , :amount => amount_due, :due_month => due_month}
    index += 1
end
puts data

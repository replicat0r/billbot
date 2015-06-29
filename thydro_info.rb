require 'rubygems'
require 'mechanize'
require 'nokogiri'

login_cred = {
    'user' => "michaelrix",
    'pass' => "jumity2014"
}
login_url = "https://css.torontohydro.com/selfserve/Pages/login.aspx"
login_field_names = {
    'user' => 'ctl00$SPWebPartManager1$g_70b63f08_8d15_4c19_8991_940d987b2a56$ctl00$membershipLogin$UserName',
    'pass' => 'ctl00$SPWebPartManager1$g_70b63f08_8d15_4c19_8991_940d987b2a56$ctl00$membershipLogin$Password'
}

mech = Mechanize.new
mech.get(login_url)
form = mech.page.form_with(:action=>/login.aspx/) 
form[login_field_names['user']] = login_cred['user']
form[login_field_names['pass']] = login_cred['pass']
form.submit(form.button_with(:value=>'Login'))
puts mech.page.parser.css("title").text.strip 
mech.get('https://css.torontohydro.com/Pages/ViewBills.aspx')
puts mech.page.parser.css("title").text.strip 

# File.open('table.html', 'w'){|f| f.puts mech.page.parser.at_css('table.tbl_bill_summary').to_html} 
# puts mech.page.parser.at_xpath('//td[ends-with(@id, "lblCusNameR")]').to_s
# puts mech.page.parser.at_xpath('//td[substring(@id, string-length(@id) - string-length("lblCusNameR") +1)]').to_s

puts "Account Number: " +mech.page.parser.css('table.tbl_bill_summary tr:nth-child(4) span div span')[0].text
puts "Balance Due: " + mech.page.parser.css('table.tbl_bill_summary tr:first-child table span')[1].text + " at " + mech.page.parser.css('table.tbl_bill_summary tr:first-child table span')[3].text

counter = 0
csv_data = ""
mech.page.parser.css('table.tbl_acc_summary tr').each{|row|
    counter = counter + 1;
    if counter == 1
        mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) th")[0..-2].each{|i| csv_data = csv_data + i.text.strip + ","}
        csv_data = csv_data + mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) th")[-1].text.strip + "\n"
    else 
        mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) td")[0..-2].each{|i| csv_data = csv_data + i.text.strip + ","}
        csv_data = csv_data + mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) td")[-1].text.strip + "\n"
    end
}
puts csv_data
# File.open('billhistory.csv', 'w'){|f| f.puts csv_data}
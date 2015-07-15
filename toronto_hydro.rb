require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'openssl'

login_cred = {
  'user' => "michaelrix",
  'pass' => "jumity2014"
}
login_url = "https://css.torontohydro.com/selfserve/Pages/login.aspx"
login_field_names = {
  'user' => 'ctl00$SPWebPartManager1$g_70b63f08_8d15_4c19_8991_940d987b2a56$ctl00$membershipLogin$UserName',
  'pass' => 'ctl00$SPWebPartManager1$g_70b63f08_8d15_4c19_8991_940d987b2a56$ctl00$membershipLogin$Password'
}

mech = Mechanize.new {|agent|
    agent.user_agent_alias = 'Mac Safari'
}
mech.get(login_url)
form = mech.page.form_with(:action=>/login.aspx/)
form[login_field_names['user']] = login_cred['user']
form[login_field_names['pass']] = login_cred['pass']
form.submit(form.button_with(:value=>'Login'))
puts mech.page.parser.css("title").text.strip
mech.get('https://css.torontohydro.com/Pages/ViewBills.aspx')
puts mech.page.parser.css("title").text.strip


# form = mech.page.form_with(:action=>/ViewBills.aspx/)
# field_name = 'ctl00$SPWebPartManager1$g_075c613b_6bec_42d8_9303_ee5f802d2cdd$ctl00$ddlStatements'
# form.field_with(:name=>field_name).options[0..-1].each do |opt|
#   form[field_name] = opt.value
#   response = form.submit(form.button_with(:value=>'Download'))
#   File.open("torontohydro_#{opt.value}.pdf", 'wb'){|f| f << response.body}
# end

counter = 0
csv_data = ""
mech.page.parser.css('table.tbl_acc_summary tr').each{|row|
  counter = counter + 1;
  if counter == 1
    mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) th")[0..-2].each{|i| csv_data = csv_data + i.text.strip + ",|"}
    csv_data = csv_data + mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) th")[-1].text.strip + "[\n"
  else
    mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) td")[0..-2].each{|i| csv_data = csv_data + i.text.strip + ",|"}
    csv_data = csv_data + mech.page.parser.css("table.tbl_acc_summary tr:nth-child(#{counter}) td")[-1].text.strip + "[\n"
  end
}
puts csv_data

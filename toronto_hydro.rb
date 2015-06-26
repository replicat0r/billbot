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
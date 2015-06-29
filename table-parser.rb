require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'fakeweb'

# table = Nokogiri::HTML(open('table.html')) 
# puts "Account Number: " + table.css('table.tbl_bill_summary tr:nth-child(4) span div span')[0].text
# puts "Balance Due: " + table.css('table.tbl_bill_summary tr:first-child table span')[1].text + " at " + table.css('table.tbl_bill_summary tr:first-child table span')[3].text
 


stream = File.read("table.html")
FakeWeb.register_uri(:get, "http://www.google.com", :body => stream, :content_type => "text/html")
mech = Mechanize.new
# table_dir = File.dirname('')
mech.get("http://www.google.com/")
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

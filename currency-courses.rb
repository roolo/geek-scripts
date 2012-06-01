#!/Users/mailo/.rvm/rubies/ruby-1.9.3-p194/bin/ruby -Ku
# encoding: UTF-8
# http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt
require "open-uri"
require 'csv'
require 'optparse'

options = {}
opt_parse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: %s [options]"%__FILE__

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
   raise NotImplementedError
  end

  options[:currencies] = %w(AUD BRL BGN CNY DKK EUR PHP HKD HRK INR IDR ILS JPY ZAR KRW CAD LTL LVL HUF MYR MXN XDR NOK NZD PLN RON RUB SGD SEK CHF THB TRY USD GBP)
  opts.on( '--with-currencies <currencies_list>', String, 'Show only given currencies separated by comma' ) do |cl|
   options[:currencies] = cl.split(",")
  end

  options[:columns] = %w(země měna množství kód kurz)
  opts.on( '--with-columns <columns_list>', String, 'Show only given columns separated by comma' ) do |cl|
   options[:columns] = cl.split(",")
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
   puts opts
   exit
  end
end

opt_parse.parse!

#uri = URI.parse("http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt")
courses_file_content = open('http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt') { |f| f.read }
courses_separated = CSV.parse(courses_file_content, col_sep: '|' )
header = courses_separated[1]


courses = courses_separated.map{ |row|
  Hash[row.map do |value|
    [header[row.index(value)], value]
  end]
}

# Get max lengths
lengths = Hash[header.map do |column_key| [column_key, 0] end ]
courses.each do |row|
  header.each do |column_key|
    unless row[column_key].nil?
      lengths[column_key] = row[column_key].length if lengths[column_key] < row[column_key].length
    end
  end
end

# Output the text
f = courses.map do |row|
  Hash[header.map do |column_key|
    # puts row[column_key].inspect
    unless lengths[column_key].nil? || row[column_key].nil?
      [column_key, row[column_key].rjust(lengths[column_key]+1, ' ')+' ']
    end
  end]
end

puts f.shift.values
puts f.shift.values.select{|label| options[:columns].include?label.strip}.join("|")

f.select {|row|
  options[:currencies].include?row['kód'].strip
}.each do |row|
  puts row.select{ |key,value|
    options[:columns].include? key
  }.values.join("|")
end


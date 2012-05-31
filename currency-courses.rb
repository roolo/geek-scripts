#!/Users/mailo/.rvm/rubies/ruby-1.9.2-p318/bin/ruby
# http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt
# require "open-uri"

# courses = open("http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt")
courses = File.read('/Users/mailo/kurzy')
          .split("\n").map do |row|
  row.split('|').map do |value|
    value
  end
end

puts courses.shift

# Get max leghts
lengths = Array.new(courses[0].length) { 0 }
courses.each do |row|
  row.each do |row_value|
    value_index = row.index(row_value)
    unless value_index.nil?
      lengths[value_index] = row_value.length if lengths[value_index] < row_value.length
    end
  end
end

# Output the text
f = courses.map do |row|
  row.map do |row_value|
    value_index = row.index(row_value)
    unless value_index.nil?
      row_value.rjust(lengths[value_index]+1, ' ')+' '
    end
  end
end

f.each do |row|
  puts row.join("|")
end
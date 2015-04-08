require 'httparty'
require 'listen'

listener = Listen.to('public/drop/') do |modified, added, removed|
  added.each do |fullpath|
    fn = fullpath.split('/').last
    puts "Added #{fn}"
    HTTParty.put('http://localhost:4567/' + fn)
  end
  modified.each do |fullpath|
    puts "Changed #{fullpath}"
  end
  removed.each do |fullpath|
    puts "Deleted #{fullpath}"
  end
end
puts "Listening for changes!"
listener.start
sleep

require 'httparty'
require 'listen'

secret = File.read('.secret')

listener = Listen.to('public/drop/') do |modified, added, removed|
  added.each do |fullpath|
    fn = fullpath.split('/').last
    if fn.match /\.JPG$/i
      puts "Added #{fn}"
      puts "convert \"public\\drop\\#{fn}\" -resize 500 \"public\\drop\\#{fn}r\""
      `convert "public\\drop\\#{fn}" -resize 500 "public\\drop\\#{fn}r"`
      HTTParty.put('http://localhost:4567/' + fn, secret: secret)
    end
  end
  modified.each do |fullpath|
    puts "Changed #{fullpath}"
  end
  removed.each do |fullpath|
    fn = fullpath.split('/').last
    if fn.match /\.JPG$/i
      puts "Deleted #{fullpath}"
      HTTParty.delete('http://localhost:4567/' + fn, secret: secret)
    end
  end
end
puts "Listening for changes!"
listener.start
sleep

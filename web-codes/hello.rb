require 'webrick'

class Hello < WEBrick::HTTPServlet::AbstractServlet
  def is_prime?(num:)
    numbers = []
    (num-2).times do |i|
      numbers.push(2+i)
    end
    numbers.select { |n| (num%n).zero? }.size.zero?
  end


  def do_GET(request, response)
    count = 0
    10000.times do |i|
      count += 1 if is_prime?(num: 2+i)
    end
    response.body   = "Hello+#{count}\n"
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(:Port => ENV['PORT'])
server.mount '/', Hello
trap 'INT' do server.shutdown end
server.start

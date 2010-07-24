NTIMES = 200000

begin_time = Time.now

puts "#{begin_time.strftime('%H:%M:%S')} -- Sending #{NTIMES} messages"

NTIMES.times do
  threads = []
  my_val = 0
  threads << Thread.new {
    my_val += 1
  }

  threads << Thread.new {
    my_val += 2
  }

  threads.each {|t| t.join}
  if my_val != 3
    puts "Value is #{my_val}"
    raise "Failed"
  end
end

end_time = Time.now
duration = end_time - begin_time
throughput = NTIMES / duration

puts "#{end_time.strftime('%H:%M:%S')} -- Finished"
puts "Duration:   #{sprintf("%0.2f", duration)} seconds"
puts "Throughput: #{sprintf("%0.2f", throughput)} messages per second"

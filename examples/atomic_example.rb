$LOAD_PATH.unshift("../lib/")
require 'atomic'

NTIMES = 200000

begin_time = Time.now

puts "#{begin_time.strftime('%H:%M:%S')} -- Sending #{NTIMES} messages"

NTIMES.times do
  threads = []
  my_atomic = Atomic.new(0)
  threads << Thread.new {
    my_atomic.update {|v| v + 1}
  }

  threads << Thread.new {
    my_atomic.update {|v| v + 2}
  }

  threads.each {|t| t.join}
  if my_atomic.value != 3
    puts "Value is #{my_atomic.value}"
    raise "Failed"
  end
end

end_time = Time.now
duration = end_time - begin_time
throughput = NTIMES / duration

puts "#{end_time.strftime('%H:%M:%S')} -- Finished"
puts "Duration:   #{sprintf("%0.2f", duration)} seconds"
puts "Throughput: #{sprintf("%0.2f", throughput)} messages per second"

#begin
#  my_atomic.try_update {|v| v + 1}
#rescue Atomic::ConcurrentUpdateError => cue
#  # deal with it (retry, propagate, etc)
#end
#puts "new value: #{my_atomic.value}"


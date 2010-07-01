$LOAD_PATH.unshift("../lib/")
require 'atomic'

class NonBlockingCounter
  def initialize
    @counter = Atomic.new(0)
  end
  def value
    return @counter.value
  end
  def increment
    begin
      @counter.try_update {|v| v + 1}
    rescue Atomic::ConcurrentUpdateError => c
      puts "Retrying now"
      retry
    end
  end
end

2000.times do |i|
counter = NonBlockingCounter.new
th = []
th << Thread.new { counter.increment }
th << Thread.new { counter.increment }
th << Thread.new { counter.increment }
th << Thread.new { counter.increment }
th.each{|t| t.join }
puts "#{i}th time - #{counter.value}"
raise "Failed #{counter.value}" if counter.value != 4
end

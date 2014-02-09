class Profiler
  #def get_memory_usage
  #  `ps -o rss= -p #{Process.pid}`.to_i
  #end
  #
  ##first option
  #  before = get_memory_usage
  #  puts  "BEFORE: " + before.to_s
  #
  #  # code here
  #
  #  after = get_memory_usage
  #  print "AFTER: " + (after-before).to_s
  #
  ##second option:
  #  pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
  #    # size = memory use in kilobytes
  #
  ##third option:
  #  puts "Frontier SIZE: " + frontier.size.to_s
  #  puts 'RAM USAGE: ' + `pmap #{Process.pid} | tail -1`[10,40].strip
end
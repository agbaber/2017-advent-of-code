@input = '0: 5
1: 2
2: 3
4: 4
6: 8
8: 4
10: 6
12: 6
14: 8
16: 6
18: 6
20: 12
22: 14
24: 8
26: 8
28: 9
30: 8
32: 8
34: 12
36: 10
38: 12
40: 12
44: 14
46: 12
48: 10
50: 12
52: 12
54: 12
56: 14
58: 12
60: 14
62: 14
64: 14
66: 14
68: 17
70: 12
72: 14
76: 14
78: 14
80: 14
82: 18
84: 14
88: 20'

firewall = []
@input.split("\n").each do |i|
  firewall<< i.split(": ").map(&:to_i)
end

columns = []
firewall.each do |f|
  columns << f[0]
end

@whole_firewall = (0..88).to_a

firewall.each do |f|
  @whole_firewall[f[0]] = f
end

@whole_firewall.each do |wf|
  if wf.is_a?(Integer)
    @whole_firewall[wf] = [wf,0]
  end
end

skips = []
@whole_firewall.each do |val|
  if val[1] != 0
    result = ((val[1]-1)*2)
    skips << result
  end
end

#find the first wait time that works for 88 then skip forward 38 every time

#88: 20

def detected_at(position, time, skip)
  # puts "position is #{position}, time is #{time}, skip is #{skip}"
  return (time % (2 + (2 * (position - 2))) ) == 0
end

@time = 0
# @detected = true
# until @detected == false
#   detected_at(88, @time, 38)
# end


#start time is 26, skip 38 each time

def not_detected?
  @whole_firewall.each do |val|
    unless val[1] == 0
      if detected_at(val[1],@wait+val[0],@wait)
        return false
      end
    end
  end
  return true
end


@wait = 12
def check_each_for_detection
  until not_detected?
    @wait +=38
  end

  puts "wait was #{@wait}"
end

check_each_for_detection
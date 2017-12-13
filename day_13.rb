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

# @input = '0: 3
# 1: 2
# 4: 4
# 6: 4'

firewall = []
@input.split("\n").each do |i|
  firewall<< i.split(": ").map(&:to_i)
end

columns = []
firewall.each do |f|
  columns << f[0]
end

whole_firewall = (0..88).to_a

firewall.each do |f|
  whole_firewall[f[0]] = f
end

whole_firewall.each do |wf|
  if wf.is_a?(Integer)
    whole_firewall[wf] = [wf,0]
  end
end

formatted_wall = []
whole_firewall.each do |wf|
  if wf[1] > 0
    foo = 'F'
  else 
    foo = 0
  end
  wf[1] = Array.new(wf[1], foo)
  wf << 'down'
  formatted_wall << wf
end

whole_firewall.each do |wf|
  unless wf[1].size == 0
    wf[1][0] = 'S'
  end
end


packet_position = 0
cost = 0

89.times do |step|
  if whole_firewall[packet_position] && whole_firewall[packet_position][1].size > 0 && whole_firewall[packet_position][1][0] == 'S'
    cost += (packet_position * whole_firewall[packet_position][1].size)
    puts "adding #{packet_position} * #{whole_firewall[packet_position][1].size}"
  end

  whole_firewall.each do |advance|
    if advance[1].size > 0
      if advance[2] == 'down' && advance[1][-1] != 'S'
        whole_firewall[advance[0]][1].rotate!(-1)
      elsif advance[2] == 'down' && advance[1][-1] == 'S'
        whole_firewall[advance[0]][2] = 'up'
        whole_firewall[advance[0]][1].rotate!(1)
      elsif advance[2] == 'up' && advance[1][0] != 'S'
        whole_firewall[advance[0]][1].rotate!(1)
      elsif advance[2] == 'up' && advance[1][0] == 'S'
        whole_firewall[advance[0]][2] = 'down'
        whole_firewall[advance[0]][1].rotate!(-1)
      end
    end
  end

  puts whole_firewall.inspect

  whole_firewall
  packet_position+=1
end

cost
#=> 1624
# not 56

__END__

--- Day 13: Packet Scanners ---

You need to cross a vast firewall. The firewall consists of several layers, each with a security
scanner that moves back and forth across the layer. To succeed, you must not be detected by a
scanner.

By studying the firewall briefly, you are able to record (in your puzzle input) the depth of each
layer and the range of the scanning area for the scanner within it, written as depth: range. Each
layer has a thickness of exactly 1. A layer at depth 0 begins immediately inside the firewall; a
layer at depth 1 would start immediately after that.

For example, suppose you've recorded the following:

0: 3
1: 2
4: 4
6: 4

This means that there is a layer immediately inside the firewall (with range 3), a second layer
immediately after that (with range 2), a third layer which begins at depth 4 (with range 4), and a
fourth layer which begins at depth 6 (also with range 4). Visually, it might look like this:

 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]

Within each layer, a security scanner moves back and forth within its range. Each security scanner
starts at the top and moves down until it reaches the bottom, then moves up until it reaches the
top, and repeats. A security scanner takes one picosecond to move one step. Drawing scanners as S,
the first few picoseconds look like this:


Picosecond 0:
 0   1   2   3   4   5   6
[S] [S] ... ... [S] ... [S]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]

Picosecond 1:
 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

Picosecond 2:
 0   1   2   3   4   5   6
[ ] [S] ... ... [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]

Picosecond 3:
 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] ... [ ]
[S] [S]         [ ]     [ ]
[ ]             [ ]     [ ]
                [S]     [S]

Your plan is to hitch a ride on a packet about to move through the firewall. The packet will travel
along the top of each layer, and it moves at one layer per picosecond. Each picosecond, the packet
moves one layer forward (its first move takes it into layer 0), and then the scanners move one step.
If there is a scanner at the top of the layer as your packet enters it, you are caught. (If a
scanner moves into the top of its layer while you are there, you are not caught: it doesn't have
time to notice you before you leave.) If you were to do this in the configuration above, marking
your current position with parentheses, your passage through the firewall would look like this:

Initial state:
 0   1   2   3   4   5   6
[S] [S] ... ... [S] ... [S]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]

Picosecond 0:
 0   1   2   3   4   5   6
(S) [S] ... ... [S] ... [S]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
( ) [ ] ... ... [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]


Picosecond 1:
 0   1   2   3   4   5   6
[ ] ( ) ... ... [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] (S) ... ... [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]


Picosecond 2:
 0   1   2   3   4   5   6
[ ] [S] (.) ... [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [ ] (.) ... [ ] ... [ ]
[S] [S]         [ ]     [ ]
[ ]             [ ]     [ ]
                [S]     [S]


Picosecond 3:
 0   1   2   3   4   5   6
[ ] [ ] ... (.) [ ] ... [ ]
[S] [S]         [ ]     [ ]
[ ]             [ ]     [ ]
                [S]     [S]

 0   1   2   3   4   5   6
[S] [S] ... (.) [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[ ]             [S]     [S]
                [ ]     [ ]


Picosecond 4:
 0   1   2   3   4   5   6
[S] [S] ... ... ( ) ... [ ]
[ ] [ ]         [ ]     [ ]
[ ]             [S]     [S]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [ ] ... ... ( ) ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]


Picosecond 5:
 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] (.) [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [S] ... ... [S] (.) [S]
[ ] [ ]         [ ]     [ ]
[S]             [ ]     [ ]
                [ ]     [ ]


Picosecond 6:
 0   1   2   3   4   5   6
[ ] [S] ... ... [S] ... (S)
[ ] [ ]         [ ]     [ ]
[S]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] ... ( )
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

In this situation, you are caught in layers 0 and 6, because your packet entered the layer when its
scanner was at the top when you entered it. You are not caught in layer 1, since the scanner moved
into the top of the layer once you were already there.

The severity of getting caught on a layer is equal to its depth multiplied by its range. (Ignore
layers in which you do not get caught.) The severity of the whole trip is the sum of these values.
In the example above, the trip severity is 0*3 + 6*4 = 24.

Given the details of the firewall you've recorded, if you leave immediately, what is the severity of
your whole trip?

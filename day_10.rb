sequence = '102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216'.bytes.to_a
sequence << [17, 31, 73, 47, 23]
sequence = sequence.flatten

list = (0..255).to_a

@current_position = 0
@skip_size = 0
# list = (0..4).to_a
# sequence = [3, 4, 1, 5]

# sequence = '1,2,3'.bytes.to_a
# sequence << [17, 31, 73, 47, 23]
# sequence = sequence.flatten

64.times do
  sequence.each do |seq|
    puts "STARTING SEQ #{seq}"
    if @current_position + seq > list.size
      puts "wrapping"
      ending_array = list[@current_position..-1]
      ending_array_size = ending_array.size
      puts "ending array is #{ending_array.inspect}"
      beginning_array = list[0...seq - ending_array.size]
      puts "beginning array is #{beginning_array.inspect}"
      beginning_array_size = beginning_array.size
      array_to_modify = ending_array + beginning_array
      puts "array_to_modify is #{array_to_modify.inspect}"
      array_to_modify.reverse!
      puts "reversed array_to_modify is #{array_to_modify.inspect}"
      # array_to_modify.rotate(@current_position)
      array_to_modify[0...ending_array_size].each_with_index do |a,i|
        list[@current_position+i] = a
      end
      puts list.inspect

      array_to_modify[-beginning_array_size..-1].each_with_index do |a,i|
        list[i] = a
      end

      puts list.inspect
    else
      puts "not wrapping"
      array_to_modify = list[@current_position...@current_position+seq]
      array_to_modify.reverse!
      array_to_modify.each_with_index do |a,i|
        list[@current_position + i] = a
      end
      puts list.inspect

    end

    if @current_position + seq + @skip_size > list.size
      @current_position = (@current_position + seq + @skip_size) % list.size
    else
      @current_position = @current_position + seq + @skip_size
    end
    puts "@current_position is #{@current_position}"
    @skip_size += 1
  end
  @list = list
end

foo = []
@list.each_slice(16) do |chunk|
  foo << chunk.inject(:^)
end

result = []
foo.each do |hex|
  if hex.to_s(16).size == 1
    result << '0' + hex.to_s(16)
  else
    result << hex.to_s(16)
  end
end

result.join

#=> 44f4befb0f303c0bafd085f97741d51d


list[0] * list[1]
#=>5577


class Matrix
  def to_readable
    i = 0
    self.each do |number|
      print number.to_s + " "
      i+= 1
      if i == self.column_size
        print "\n"
        i = 0
      end
    end
  end

  def []=(i, j, x)
    @rows[i][j] = x
  end
end

__END__

--- Day 10: Knot Hash ---

You come across some programs that are trying to implement a software emulation of a hash based on
knot-tying. The hash these programs are implementing isn't very strong, but you decide to help them
anyway. You make a mental note to remind the Elves later not to invent their own cryptographic
functions.

This hash function simulates tying a knot in a circle of string with 256 marks on it. Based on the
input to be hashed, the function repeatedly selects a span of string, brings the ends together, and
gives the span a half-twist to reverse the order of the marks within it. After doing this many
times, the order of the marks is used to build the resulting hash.

  4--5   pinch   4  5           4   1
 /    \  5,0,1  / \/ \  twist  / \ / \
3      0  -->  3      0  -->  3   X   0
 \    /         \ /\ /         \ / \ /
  2--1           2  1           2   5
To achieve this, begin with a list of numbers from 0 to 255, a current position which begins at 0
  (the first element in the list), a skip size (which starts at 0), and a sequence of lengths (your
    puzzle input). Then, for each length:

Reverse the order of that length of elements in the list, starting with the element at the current
position.
Move the current position forward by that length plus the skip size.
Increase the skip size by one.
The list is circular; if the current position and the length try to reverse elements beyond the end
of the list, the operation reverses using as many extra elements as it needs from the front of the
list. If the current position moves past the end of the list, it wraps around to the front. Lengths
larger than the size of the list are invalid.

Here's an example using a smaller list:

Suppose we instead only had a circular list containing five elements, 0, 1, 2, 3, 4, and were given
input lengths of 3, 4, 1, 5.

The list begins as [0] 1 2 3 4 (where square brackets indicate the current position).
The first length, 3, selects ([0] 1 2) 3 4 (where parentheses indicate the sublist to be reversed).
After reversing that section (0 1 2 into 2 1 0), we get ([2] 1 0) 3 4.
Then, the current position moves forward by the length, 3, plus the skip size, 0: 2 1 0 [3] 4.
Finally, the skip size increases to 1.
The second length, 4, selects a section which wraps: 2 1) 0 ([3] 4.
The sublist 3 4 2 1 is reversed to form 1 2 4 3: 4 3) 0 ([1] 2.
The current position moves forward by the length plus the skip size, a total of 5, causing it not
to move because it wraps around: 4 3 0 [1] 2. The skip size increases to 2.
The third length, 1, selects a sublist of a single element, and so reversing it has no effect.
The current position moves forward by the length (1) plus the skip size (2): 4 [3] 0 1 2. The skip
size increases to 3.
The fourth length, 5, selects every element starting with the second: 4) ([3] 0 1 2. Reversing this
sublist (3 0 1 2 4 into 4 2 1 0 3) produces: 3) ([4] 2 1 0.
Finally, the current position moves forward by 8: 3 4 2 1 [0]. The skip size increases to 4.
In this example, the first two numbers in the list end up being 3 and 4; to check the process, you
can multiply them together to produce 12.

However, you should instead use the standard list size of 256 (with values 0 to 255) and the
sequence of lengths in your puzzle input. Once this process is complete, what is the result of
multiplying the first two numbers in the list?
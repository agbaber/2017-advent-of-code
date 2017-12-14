@input = 'ugkiagan'

source = []
(0..127).to_a.each do |a|
  foo = @input + '-'+ a.to_s
  source << foo
end

# binary = []
# source.each do |s|
#   in_binary = []
#   s.each_char do |char|
#     result = char.hex.to_s(2).rjust(num.size*4, '0')
#     in_binary << result
#   end
#   binary << in_binary.join()
# end

# convert to bits
# num = '0'
# num.hex.to_s(2).rjust(num.size*4, '0')
#=> '0000'




def to_binary(input)
  binary = []
  input.each_char do |char|
    result = char.hex.to_s(2).rjust(char.size*4, '0')
    binary << result
  end
  binary.join()
end



# day 10 part 2

def knot_hash(input)
  sequence = input.bytes.to_a
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
end

hashes = []
source.each do |s|
  hashes << knot_hash(s)
end

final = []
hashes.each do |h|
  final << to_binary(h)
end

counts = Hash.new 0
final.join('').split('').each do |i|
  counts[i] +=1
end
counts["1"]
#=> 8292


# part 2
require 'matrix'

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

def check_neighbors(row,column)
  if (row - 1) >= 0 && @matrix[row-1,column] == '1'
    @matrix[row-1,column] = nil
    check_neighbors(row-1, column)
  end

  if (column - 1) >= 0 && @matrix[row,column-1] == '1'
    @matrix[row,column-1] = nil
    check_neighbors(row, column-1)
  end

  if (row + 1) <= 128 && @matrix[row+1,column] == '1'
    @matrix[row+1,column] = nil
    check_neighbors(row+1,column)
  end

  if (column + 1) <= 128 && @matrix[row,column+1] == '1'
    @matrix[row,column+1] = nil
    check_neighbors(row,column+1)
  end
end

@matrix = Matrix.rows(final.map{|x| x.split('')})

group_number = 0

@matrix.each_with_index do |value, row, column|
  if value == '0'
    @matrix[row,column] = nil
  elsif value == '1'
    check_neighbors(row, column)
    @matrix[row,column] = nil
    group_number+=1
  end
end



group_number
#=> 1033 too low
#=> 1070 too high
#=> 1069 just riiiiight

__END__

--- Day 14: Disk Defragmentation ---

Suddenly, a scheduled job activates the system's disk defragmenter. Were the situation different,
you might sit and watch it for a while, but today, you just don't have that kind of time. It's
soaking up valuable system resources that are needed elsewhere, and so the only option is to help it
finish its task as soon as possible.

The disk in question consists of a 128x128 grid; each square of the grid is either free or used. On
this disk, the state of the grid is tracked by the bits in a sequence of knot hashes.

A total of 128 knot hashes are calculated, each corresponding to a single row in the grid; each hash
contains 128 bits which correspond to individual grid squares. Each bit of a hash indicates whether
that square is free (0) or used (1).

The hash inputs are a key string (your puzzle input), a dash, and a number from 0 to 127
corresponding to the row. For example, if your key string were flqrgnkx, then the first row would be
given by the bits of the knot hash of flqrgnkx-0, the second row from the bits of the knot hash of
flqrgnkx-1, and so on until the last row, flqrgnkx-127.

The output of a knot hash is traditionally represented by 32 hexadecimal digits; each of these
digits correspond to 4 bits, for a total of 4 * 32 = 128 bits. To convert to bits, turn each
hexadecimal digit to its equivalent binary value, high-bit first: 0 becomes 0000, 1 becomes 0001, e
becomes 1110, f becomes 1111, and so on; a hash that begins with a0c2017... in hexadecimal would
begin with 10100000110000100000000101110000... in binary.

Continuing this process, the first 8 rows and columns for key flqrgnkx appear as follows, using # to
denote used squares, and . to denote free ones:

##.#.#..-->
.#.#.#.#   
....#.#.   
#.#.##.#   
.##.#...   
##..#..#   
.#...#..   
##.#.##.-->
|      |   
V      V   

In this example, 8108 squares are used across the entire 128x128 grid.

Given your actual key string, how many squares are used?

Your puzzle input is ugkiagan.


--- Part Two ---

Now, all the defragmenter needs to know is the number of regions. A region is a group of used
squares that are all adjacent, not including diagonals. Every used square is in exactly one region:
lone used squares form their own isolated regions, while several adjacent squares all count as a
single region.

In the example above, the following nine regions are visible, each marked with a distinct digit:

11.2.3..-->
.1.2.3.4   
....5.6.   
7.8.55.9   
.88.5...   
88..5..8   
.8...8..   
88.8.88.-->
|      |   
V      V   


Of particular interest is the region marked 8; while it does not appear contiguous in this small
view, all of the squares marked 8 are connected when considering the whole 128x128 grid. In total,
in this example, 1242 regions are present.

How many regions are present given your key string?

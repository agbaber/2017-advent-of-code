#figure out what the coordinates are for the input
#figure out the distance from the center



def find_ring(number)
  until @array[-1] >= number do
    @array << (@i * 8) + @array[-1]
    @i+=1
    @i # this is one more than the ring #
  end
  @ring = @i - 1
end


def find_distance_from_mid
  first_num = @array[-2]+1 # this is the first number of the ring it's on
  @ring = [*@array[-2]+1..@array[-1]] # all the numbers in the @ring
  (@ring.size / 4)-1 #the amount of numbers on each side (no corners)
  first_jump = (@ring.size / 8)-1 # first jump to middle amount
  first_mid = first_num + first_jump
  second_mid = first_mid + @ring.size / 4
  third_mid = second_mid + @ring.size / 4
  fourth_mid = third_mid + @ring.size / 4
  middle_array = [first_mid, second_mid, third_mid, fourth_mid]
  
  distance_from_mid = []
  middle_array.each do |num|
    distance_from_mid << (num - @number).abs
  end
  distance = distance_from_mid.min
  answer = @ring_number + distance
  answer
end

def run(num, answer)
  @number = num
  @i = 1
  @array = [1]
  @ring_number = find_ring(@number)
  result = find_distance_from_mid
  if answer.nil?
    puts "answer is #{result}"
  elsif
    result == answer
    puts 'answer correct'
  else
    puts "answer incorrect, expected #{answer}, got #{result}"
  end
end

tests = [[12,3],[23,2],[1024,31]]

tests.each do |test|
  run(test[0],test[1])
end

run(312051, nil)


# part 2

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

def sum_of_neighbors(y,x)
  sum = @matrix[x-1,y] + # all the neighbors
  @matrix[x-1,y-1] +
  @matrix[x,y-1] +
  @matrix[x+1,y] + 
  @matrix[x,y+1] +
  @matrix[x+1,y+1] +
  @matrix[x-1,y+1] +
  @matrix[x+1,y-1]
  sum
end



@matrix = Matrix.zero(21)
y = 10
x = 10
@matrix[y,x] = 1

ring = 1
x+=1
numbers_per_side = ring * 2

numbers_per_side.times do |side|
  @matrix[y,x] = sum_of_neighbors(y,x)
  y-=1
end

@matrix.to_readable







def find_next_number(input)
  matrix = Matrix.zero(21)

  @ring = 0
  @number = 1
  x = 10
  y = 10

  matrix[x,y] = 1

  (1..4).each do |ring|
    numbers_per_side = ring * 2
    y+=1
    start = x
    numbers_per_side.times do |up|
      
      matrix[x,y] = matrix[x-1,y] + # all the neighbors
        matrix[x-1,y-1] +
        matrix[x,y-1] +
        matrix[x+1,y] + 
        matrix[x,y+1] +
        matrix[x+1,y+1] +
        matrix[x-1,y+1] +
        matrix[x+1,y-1]
      unless start-x == numbers_per_side -1
        x-=1
      end
    end


    numbers_per_side.times do |left|
      y-=1
      matrix[x,y] = 
      matrix[x-1,y] + # all the neighbors
      matrix[x-1,y-1] +
      matrix[x,y-1] +
      matrix[x+1,y] + 
      matrix[x,y+1] +
      matrix[x+1,y+1] +
      matrix[x-1,y+1] +
      matrix[x+1,y-1]
    end

    numbers_per_side.times do |down|
      x+=1
      matrix[x,y] = 
      matrix[x-1,y] + # all the neighbors
      matrix[x-1,y-1] +
      matrix[x,y-1] +
      matrix[x+1,y] + 
      matrix[x,y+1] +
      matrix[x+1,y+1] +
      matrix[x-1,y+1] +
      matrix[x+1,y-1]
    end

    numbers_per_side.times do |right|
      y+=1
      matrix[x,y] = 
      matrix[x-1,y] + # all the neighbors
      matrix[x-1,y-1] +
      matrix[x,y-1] +
      matrix[x+1,y] + 
      matrix[x,y+1] +
      matrix[x+1,y+1] +
      matrix[x-1,y+1] +
      matrix[x+1,y-1]
    end
  end

  matrix.to_readable
end


__END__
--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and 
hen counting up while spiraling outward. For example, the first few squares are allocated 
like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...
While this is very space-efficient (no squares are skipped), requested data must be 
carried back to square 1 (the location of the only access port for this memory system) 
by programs that can only move up, down, left, or right. They always take the shortest 
path: the Manhattan Distance between the location of the data and square 1.

For example:

Data from square 1 is carried 0 steps, since it's at the access port.
Data from square 12 is carried 3 steps, such as: down, left, left.
Data from square 23 is carried only 2 steps: up twice.
Data from square 1024 must be carried 31 steps.
How many steps are required to carry the data from the square identified in your puzzle 
input all the way to the access port?

Your puzzle input is 312051.
65  64  63  62  61  60  59  58  57

66  37  36  35  34  33  32  31  56

67  38  17  16  15  14  13  30  55

68  39  18   5   4   3  12  29  54

69  40  19   6   1   2  11  28  53

70  41  20   7   8   9  10  27  52

71  42  21  22  23  24  25  26  51

72  43  44  45  46  47  48  49  50

73  74  75  76  77  78  79  80  81  82
                                   
                                    121

given 50, need to find 53, 61, 69, 77
                        3, 8, 8, 8
                        total ring is 32
                        32 / 4 / 2 - 1 to get first jump
                        first + first jump + ring size / 4  = each mid



1, 8, 16, 24, 32

last numbers of each
1, 9, 25, 49, 81
(8, 16, 24, 32)

n + n(8+n) 

input / 8 rounded down is the ring # (rings start at 0 = ring 1) - wrong
input % 8 is the position, starting at bottom right (position 1)
input / 8 rounded down + 2 is the # of numbers per side




--- Part Two ---

As a stress test on the system, the programs here clear the grid and then store the value 
1 in square 1. Then, in the same allocation order as shown above, they store the sum of the 
alues in all adjacent squares, including diagonals.

So, the first few squares' values are chosen as follows:

Square 1 starts with the value 1.
Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
Square 4 has all three of the aforementioned squares as neighbors and stores the sum of 
their values, 4.
Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
Once a square is written, its value does not change. Therefore, the first few squares 
would receive the following values:

147  142  133  122   59

304    5    4    2   57

330   10    1    1   54

351   11   23   25   26

362  747  806--->   ...
What is the first value written that is larger than your puzzle input?
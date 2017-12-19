@input = <<-EOM
set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 680
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19
EOM

# @input = <<-EOM
# set a 1
# add a 2
# mul a a
# mod a 5
# snd a
# set a 0
# rcv a
# jgz a -1
# set a 1
# jgz a -2
# EOM

@instructions = []
@input.chomp.split("\n").each_with_index do |instruction,i|
  compiled = instruction.split(' ')
  compiled << i
  @instructions << compiled
end

@registers = Hash.new 0
letters = ['a','i','p','b','f']
letters.each do |l|
  @registers[l] = 0
end

@last_sound_played = 0

# def do_instructions
#   start_index = @start_index
#   @instructions[start_index..-1].each do |instruction|
#     puts ">>>"

#     puts "#{instruction.inspect}"
#     case instruction[0]
#     when 'snd'
#       @last_sound_played = @registers[instruction[1]]
#     when 'set'
#       if instruction[2].to_i.to_s == instruction[2]
#         @registers[instruction[1]] = instruction[2]
#       else
#         @registers[instruction[1]] = @registers[instruction[2]]
#       end
#     when 'add'
#       if instruction[2].to_i.to_s == instruction[2]
#         @registers[instruction[1]] = @registers[instruction[1]].to_i + instruction[2].to_i
#       else
#         @registers[instruction[1]] = @registers[instruction[1]].to_i + @registers[instruction[2]].to_i
#       end
#     when 'mul'
#       if instruction[2].to_i.to_s == instruction[2]
#         @registers[instruction[1]] = @registers[instruction[1]].to_i * instruction[2].to_i
#       else
#         @registers[instruction[1]] = @registers[instruction[1]].to_i * @registers[instruction[2]].to_i
#       end
#     when 'mod'
#       if instruction[2].to_i.to_s == instruction[2]
#         @registers[instruction[1]] = (@registers[instruction[1]].to_i % instruction[2].to_i)
#       else
#         result = (@registers[instruction[1]].to_i % @registers[instruction[2]].to_i)
#         puts result
#         @registers[instruction[1]] = result
#       end
#     when 'rcv'
#       if @last_sound_played != 0
#         @registers[instruction[1]] = @last_sound_played
#         puts "last_sound_played #{@last_sound_played}"
#         @it_happened = true
#         break
#       else
#       end
#     when 'jgz'
#       check_num = (instruction[1].to_i.to_s == instruction[1])

#       if (check_num && instruction[1].to_i > 0) || @registers[instruction[1]].to_i > 0
#         if instruction[2].to_i.to_s == instruction[2]
#           @start_index = (instruction[2].to_i + instruction[3] -1)
#           # @start_index < 0 ? @start_index -=1 : @start_index +=1
            
#           puts "jumping"
#           break
#         else
#           @start_index = (@registers[instruction[2]] + instruction[3])
#           puts "jumping"
#           break
#         end
#       end
#     end
#     puts @registers.inspect
#   end
#   @start_index +=1
# end


def do_instructions_1
  instruction = @instructions[@start_index_1]
    # puts instruction.inspect
    # puts ">>>"

    puts "#{instruction.inspect}"
    case instruction[0]
    when 'snd'
      @t1_send << @t1_registers[instruction[1]]
      # puts "t1 send #{@t1_send}"
      # puts "t1_send_count #{@t1_send_count}"
      @t2_waiting = false
      @start_index_1 +=1
    when 'set'
      # puts instruction[2]
      if instruction[2].to_i.to_s == instruction[2]
        @t1_registers[instruction[1]] = instruction[2]
      else
        @t1_registers[instruction[1]] = @t1_registers[instruction[2]]
      end
      @start_index_1 +=1
    when 'add'
      if instruction[2].to_i.to_s == instruction[2]
        @t1_registers[instruction[1]] = @t1_registers[instruction[1]].to_i + instruction[2].to_i
      else
        @t1_registers[instruction[1]] = @t1_registers[instruction[1]].to_i + @t1_registers[instruction[2]].to_i
      end
      @start_index_1 +=1
    when 'mul'
      if instruction[2].to_i.to_s == instruction[2]
        @t1_registers[instruction[1]] = @t1_registers[instruction[1]].to_i * instruction[2].to_i
      else
        @t1_registers[instruction[1]] = @t1_registers[instruction[1]].to_i * @t1_registers[instruction[2]].to_i
      end
      @start_index_1 +=1
    when 'mod'
      if instruction[2].to_i.to_s == instruction[2]
        @t1_registers[instruction[1]] = (@t1_registers[instruction[1]].to_i % instruction[2].to_i)
      else
        result = (@t1_registers[instruction[1]].to_i % @t1_registers[instruction[2]].to_i)
        # puts result
        @t1_registers[instruction[1]] = result
      end
      @start_index_1 +=1
    when 'rcv'
      if @t2_send.empty?
        # puts 'waiting'
        # puts '!!!!'
        @t1_waiting = true
      else
        # puts '????'
        @t1_registers[instruction[1]] = @t2_send[0]
        @t2_send.shift(1)
        @t1_waiting = false
        @start_index_1 +=1
      end
    when 'jgz'
      # puts instruction.inspect
      # puts instruction[1].inspect
      # puts instruction[2].inspect
      # puts instruction[3].inspect
      check_num = (instruction[1].to_i.to_s == instruction[1])

      if (check_num && instruction[1].to_i > 0) || @t1_registers[instruction[1]].to_i > 0
        if instruction[2].to_i.to_s == instruction[2]
          @start_index_1 = (instruction[2].to_i + instruction[3] )
          # @start_index < 0 ? @start_index -=1 : @start_index +=1
            
          # puts "jumping"
        else
          # puts "instruction 2 is #{instruction[2]} and instruciton 3 is instruction[3]"
          @start_index_1 = (@t1_registers[instruction[2]] + @t1_registers[instruction[3]])
          # puts "jumping"
        end
      else
        @start_index_1 +=1
      end
    end
    # puts @t1_registers.inspect
end

def do_instructions_2
  instruction = @instructions[@start_index_2]
    # puts ">>>"

    puts "#{instruction.inspect}"
    case instruction[0]
    when 'snd'
      @t2_send << @t2_registers[instruction[1]]
      @t2_send_count += 1
      @t1_waiting = false
      @start_index_2 +=1
      # puts "t2 send #{@t2_send}"
    when 'set'
      if instruction[2].to_i.to_s == instruction[2]
        @t2_registers[instruction[1]] = instruction[2]
      else
        @t2_registers[instruction[1]] = @t2_registers[instruction[2]]
      end
      @start_index_2 +=1
    when 'add'
      if instruction[2].to_i.to_s == instruction[2]
        @t2_registers[instruction[1]] = @t2_registers[instruction[1]].to_i + instruction[2].to_i
      else
        @t2_registers[instruction[1]] = @t2_registers[instruction[1]].to_i + @t2_registers[instruction[2]].to_i
      end
      @start_index_2 +=1
    when 'mul'
      if instruction[2].to_i.to_s == instruction[2]
        @t2_registers[instruction[1]] = @t2_registers[instruction[1]].to_i * instruction[2].to_i
      else
        @t2_registers[instruction[1]] = @t2_registers[instruction[1]].to_i * @t2_registers[instruction[2]].to_i
      end
      @start_index_2 +=1
    when 'mod'
      if instruction[2].to_i.to_s == instruction[2]
        @t2_registers[instruction[1]] = (@t2_registers[instruction[1]].to_i % instruction[2].to_i)
      else
        result = (@t2_registers[instruction[1]].to_i % @t2_registers[instruction[2]].to_i)
        # puts result
        @t2_registers[instruction[1]] = result
      end
      @start_index_2 +=1
    when 'rcv'
      if @t1_send.empty?
        # puts 'waiting2'
        # puts '!!!!'
        @t2_waiting = true
      else
        # puts '????'
        @t2_registers[instruction[1]] = @t1_send[0]
        @t1_send.shift(1)
        @t2_waiting = false
        @start_index_2 +=1
      end
    when 'jgz'
      check_num = (instruction[1].to_i.to_s == instruction[1])

      if (check_num && instruction[1].to_i > 0) || @t2_registers[instruction[1]].to_i > 0
        if instruction[2].to_i.to_s == instruction[2]
          @start_index_2 = (instruction[2].to_i + instruction[3] )
          # @start_index < 0 ? @start_index -=1 : @start_index +=1
            
          # puts "jumping"
        else
          @start_index_2 = (@t2_registers[instruction[2]] + @t2_registers[instruction[3]])
          # puts "jumping"
        end
      else
        @start_index_2 +=1
      end
    end
    # puts @t2_registers.inspect
end

# @start_index = 0
# @it_happened = false
# until @it_happened
#   do_instructions
# end

# in t1 p starts at 0
# in t2 p starts at 1

@t1_registers = @registers.dup
@t2_registers = @registers.dup
@t2_registers['p'] = 1
@t1_send = []
@t2_send = []
@start_index_1 = 0
@start_index_2 = 0
@t2_send_count = 0
@t1_waiting = false
@t2_waiting = false

# until @t1_waiting
#   do_instructions_1
# end

# until @t2_waiting
#   do_instructions_2
# end
until @t1_waiting && @t2_waiting
    100.times do do_instructions_1 end
  # until @t2_waiting || @start_index_2 > @instructions.size
  #   do_instructions_2
  #   puts @t2_send.inspect
  # end

    100.times do do_instructions_2 end
  # puts "@t1_waiting #{@t1_waiting}"
  # puts "@t2_waiting #{@t2_waiting}"
end

puts "t2 send is #{@t2_send_count}"

#not 6142 - too high
#not 1


# part 2 not 24
# not 12
# 128 too low
# 7112


__END__
--- Day 18: Duet --- You discover a tablet containing some strange assembly code labeled
simply "Duet". Rather than bother the sound card with it, you decide to run the code yourself.
Unfortunately, you don't see any documentation, so you're left to figure out what the instructions
mean on your own.

It seems like the assembly is meant to operate on a set of registers that are each named with a
single letter and that can each hold a single integer. You suppose each register should start with a
value of 0.

There aren't that many instructions, so it shouldn't be hard to figure out what they do. Here's what
you determine:

snd X plays a sound with a frequency equal to the value of X.
set X Y sets register X to the value of Y.
add X Y increases register X by the value of Y.
mul X Y sets register X to the result of multiplying the value contained in register X by the value
of Y.
mod X Y sets register X to the remainder of dividing the value contained in register X by the value
of Y (that is, it sets X to the result of X modulo Y).
rcv X recovers the frequency of the last sound played, but only when the value of X is not zero.
(If it is zero, the command does nothing.)
jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero.
(An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction,
  and so on.)
Many of the instructions can take either a register (a single letter) or a number. The value of a
register is the integer it contains; the value of a number is that number.

After each jump instruction, the program continues with the instruction to which the jump jumped.
After any other instruction, the program continues with the next instruction. Continuing (or
jumping) off either end of the program terminates it.

For example:

set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2

The first four instructions set a to 1, add 2 to it, square it, and then set it to itself modulo 5,
resulting in a value of 4. Then, a sound with frequency 4 (the value of a) is played. After that, a
is set to 0, causing the subsequent rcv and jgz instructions to both be skipped (rcv because a is 0,
and jgz because a is not greater than 0). Finally, a is set to 1, causing the next jgz instruction
to activate, jumping back two instructions to another jump, which jumps again to the rcv, which
ultimately triggers the recover operation. At the time the recover operation is executed, the
frequency of the last sound played is 4.

What is the value of the recovered frequency (the value of the most recently played sound) the first
time a rcv instruction is executed with a non-zero value?

--- Part Two ---

As you congratulate yourself for a job well done, you notice that the documentation has been on the
back of the tablet this entire time. While you actually got most of the instructions correct, there
are a few key differences. This assembly code isn't about sound at all - it's meant to be run twice
at the same time.

Each running copy of the program has its own set of registers and follows the code independently -
in fact, the programs don't even necessarily run at the same speed. To coordinate, they use the send
(snd) and receive (rcv) instructions:

snd X sends the value of X to the other program. These values wait in a queue until that program is
ready to receive them. Each program has its own message queue, so a program can never receive a
message it sent.
rcv X receives the next value and stores it in register X. If no values are in the queue, the
program waits for a value to be sent to it. Programs do not continue to the next instruction until
  they have received a value. Values are received in the order they are sent.
Each program also has its own program ID (one 0 and the other 1); the register p should begin with
  this value.

For example:

snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d


Both programs begin by sending three values to the other. Program 0 sends 1, 2, 0; program 1 sends
1, 2, 1. Then, each program receives a value (both 1) and stores it in a, receives another value
(both 2) and stores it in b, and then each receives the program ID of the other program (program 0
receives 1; program 1 receives 0) and stores it in c. Each program now sees a different value in its
own copy of register c.

Finally, both programs try to rcv a fourth time, but no data is waiting for either of them, and they
reach a deadlock. When this happens, both programs terminate.

It should be noted that it would be equally valid for the programs to run at different speeds; for
example, program 0 might have sent all three values and then stopped at the first rcv before program
1 executed even its first instruction.

Once both of your programs have terminated (regardless of what caused them to do so), how many times
did program 1 send a value?


$input = <<-EOM
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

# ok time to give up on refactoring this back into a workable solution. stealing it from austen
# fml


class SoundProcessingUnit
  def initialize ab
    @instructions = []
    @program_counter = 0
    @register_file = Hash.new(0)
    @register_file['p'] = ab

    @io_queue = []
    @io_target = nil
    @io_blocking = false
    @running = true
    @send_count = 0
  end

  def pair_io io_target
    @io_target = io_target
  end

  def send_io arg
    if @io_target != nil
      @io_target.io(arg)
    end
  end

  def io arg
    @io_queue.push(arg)
  end

  def get_value arg
    v = nil
    if /([a-z]+)/.match arg.to_s
      v = @register_file[arg]
    else
      v = arg.to_i
    end
    return v
  end

  def exec(cmd, arg1, arg2)
    v = nil
    if arg2 != nil
      v = get_value(arg2)
    end

    case cmd
    when 'snd'
      send_io(get_value(arg1))
      @send_count += 1
    when 'set'
      @register_file[arg1] = v.to_i
    when 'add'
      @register_file[arg1] += v.to_i
    when 'mul'
      @register_file[arg1] = @register_file[arg1].to_i * v.to_i
    when 'mod'
      @register_file[arg1] = @register_file[arg1].to_i % v.to_i
    when 'rcv'
      if @io_queue.empty?
        @io_blocking = true
        return
      else
        @io_blocking = false
        @register_file[arg1] = get_value(@io_queue.shift()).to_i
      end
    when 'jgz'
      if get_value(arg1) > 0 then
        @program_counter += get_value(arg2)
        return
      end
    end
    @program_counter += 1
  end

  def fetch_instruction
    if @program_counter < 0 or @program_counter >= @instructions.length then
      print "Program Terminated\n"
      @running = false
    else
      return @instructions[@program_counter]
    end
    return nil
  end

  def step
    if @running then
      op = fetch_instruction
      if op != nil
        exec(op[:op], op[:a], op[:b])
      end
    end
  end

  def blocked?
    return @io_blocking
  end

  def running?
    return @running
  end

  def run
    while @running do
      step
    end
  end

  def get_send_count
    return @send_count
  end

  def compile(filename)
    $input.chomp.each_line do |line|
      parts = line.split(" ")
      @instructions.push({op: parts[0], a: parts[1], b: parts.length > 2 ? parts[2] : nil})
    end
  end
end

vm_a = SoundProcessingUnit.new 0
vm_b = SoundProcessingUnit.new 1
vm_a.pair_io(vm_b)
vm_b.pair_io(vm_a)
vm_a.compile(ARGV[0])
vm_b.compile(ARGV[0])

while vm_a.running? or vm_b.running? do
  if vm_a.blocked? and vm_b.blocked?
    print "Deadlock encountered\n"
    break
  end
  vm_a.step
  vm_b.step
end

print vm_b.get_send_count, "\n"
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


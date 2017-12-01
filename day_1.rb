#!/usr/bin/env ruby

input = '61697637962276641366442297247367117738114719863473648131982449728688116728695866572989524473392982963976411147683588415878214189996163533584547175794158118148724298832798898333399786561459152644144669959887341481968319172987357989785791366732849932788343772112176614723858474959919713855398876956427631354172668133549845585632211935573662181331613137869866693259374322169811683635325321597242889358147123358117774914653787371368574784376721652181792371635288376729784967526824915192526744935187989571347746222113625577963476141923187534658445615596987614385911513939292257263723518774888174635963254624769684533531443745729344341973746469326838186248448483587477563285867499956446218775232374383433921835993136463383628861115573142854358943291148766299653633195582135934544964657663198387794442443531964615169655243652696782443394639169687847463721585527947839992182415393199964893658322757634675274422993237955354185194868638454891442893935694454324235968155913963282642649968153284626154111478389914316765783434365458352785868895582488312334931317935669453447478936938533669921165437373741448378477391812779971528975478298688754939216421429251727555596481943322266289527996672856387648674166997731342558986575258793261986817177487197512282162964167151259485744835854547513341322647732662443512251886771887651614177679229984271191292374755915457372775856178539965131319568278252326242615151412772254257847413799811417287481321745372879513766235745347872632946776538173667371228977212143996391617974367923439923774388523845589769341351167311398787797583543434725374343611724379399566197432154146881344528319826434554239373666962546271299717743591225567564655511353255197516515213963862383762258959957474789718564758843367325794589886852413314713698911855183778978722558742329429867239261464773646389484318446574375323674136638452173815176732385468675215264736786242866295648997365412637499692817747937982628518926381939279935993712418938567488289246779458432179335139731952167527521377546376518126276'

tests = ['1122', 3], ['1111', 4], ['1234', 0], ['91212129', 9]

tests_part_2 = ['1212', 6], ['1221', 0], ['123425', 4], ['123123', 12], ['12131415', 4]

# take the input, split into array, take the first char, add to the end
def split_input(input)
  array = input.split('')
  array << array[0]
end

def split_input_part_2(input)
  array = input.split('')
  @jump = array.size / 2
  array << array[0..@jump-1]
  array.flatten
end


# go through each, starting at 0, look at the next char, if they are equal, add that # to matching array
def match_array(array)
  matching_array = []

  array.each_with_index do |num, i|
    if num == array[i + 1]
      matching_array << num
    end
  end

  matching_array
end

def match_array_part_2(array)
  matching_array = []

  array.each_with_index do |num, i|
    if num == array[i + @jump]
      matching_array << num
    end
  end

  matching_array
end

# take new array, sum all values
def get_answer(matching_array)
  matching_array.map(&:to_i).inject(:+)
end

# test values part 1
tests.each do |test|
  array = split_input(test[0])
  matching_array = match_array(array)
  result = get_answer(matching_array)

  if result.nil?
    result = 0
  end

  if test[1] == result
    puts 'test passed'
  else
    puts "test failed, result was #{result} and should have been #{test[1]}"
  end
end

# final result

get_answer(match_array(split_input(input)))
# => 1182


# test values part 2
tests_part_2.each do |test|
  array = split_input_part_2(test[0])
  matching_array = match_array_part_2(array)
  result = get_answer(matching_array)

  if result.nil?
    result = 0
  end

  if test[1] == result
    puts 'test passed'
  else
    puts "test failed, result was #{result} and should have been #{test[1]}"
  end
end

# final result part 2
get_answer(match_array_part_2(split_input_part_2(input)))
#=> 1152


__END__
The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all
digits that match the next digit in the list. The list is circular, so the digit after the last
digit is the first digit in the list.

For example:

1122 produces a sum of 3 (1 + 2) because the first digit (1) matches the second digit and the third
digit (2) matches the fourth digit.
1111 produces 4 because each digit (all 1) matches the next.
1234 produces 0 because no digit matches the next.
91212129 produces 9 because the only digit that matches the next one is the last digit, 9.


--- Part Two ---

You notice a progress bar that jumps to 50% completion. Apparently, the door isn't yet satisfied,
but it did emit a star as encouragement. The instructions change:

Now, instead of considering the next digit, it wants you to consider the digit halfway around the
circular list. That is, if your list contains 10 items, only include a digit in your sum if the
digit 10/2 = 5 steps forward matches it. Fortunately, your list has an even number of elements.

For example:

1212 produces 6: the list contains 4 items, and all four digits match the digit 2 items ahead.
1221 produces 0, because every comparison is between a 1 and a 2.
123425 produces 4, because both 2s match each other, but no other digit has a match.
123123 produces 12.
12131415 produces 4.
What is the solution to your new captcha?
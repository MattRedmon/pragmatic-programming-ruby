# CHAP 3 - CONTAINTERS, BLOCKS, AND ITERATORS

# ARRAYS
=begin
a = [ 3.14, "pie", 99 ]
a.type      # => Array
a.length    # => 3
a[0]        # => 3.14
a[1]        # => "pie"
a[2]        # => 99
a[3]        # => nil

b = Array.new
b.type      # => Array
b.length    # => 0
b[0] = "second"
b[1] = "array"
b           # => ["second", "array"]

# Arrays are indexed using the [] operator which is actually a method in the class Array
# since [] is a method it can be over ridden in subclasses

# arrays can be accessed with negative numbers counting backwards from the end
a = [1,3,5,7,9]
a[-1]       # => 9
a[-2]       # => 7
a[-99]      # => nil

# arrays can be accessed with a pair of numbers [start, count]
a = [1,3,5,7,9]
a[1,3]      # => [3,5,7]     start at position 1 and count out 3
a[3,1]      # => [7]         start at position 3 and count out 1
a[-3,2]     # => [5,7]       start at position -3 and count out 2

# arrays can be accessed using ranges with start and end position separated by either 2 or 3 periods
# the two period form includes the end position
# the three period form does not include the end position
a = [1,3,5,7,9]
a[1..3]     # => [3,5,7]
a[1...3]    # => [3,5]
a[3..3]     # => [7]
a[-3..-1]   # => [5,7,9]

# the [] operator has a corresponding []= operator which lets you set element in the array
a = [1,3,5,7,9]
a[1] = "bat"   # => [1,"bat",5 7 9]
a[-3] = "cat"  # => [1,"bat","cat",7,9]
a[3] = [9,8]   # => [1,"bat","cat",[9,8],9]
a[6] = 99      # => [1,"bat", "cat",[9.8],9, nil, 99]

# if the index to []= is two numbers or a range then those elements in original array
# are replaced by whatever is on the right hand side of the assignment
a = [1,3,5,7,9]
a[2,2] = "cat"    # => [1,3,"cat",9]   start at position 2 and "cat" takes up two spots ousting 5 + 7
a[2,0] = "dog"    # => [1,3,"dog","cat",9]   start at position 2, take up zero spots, so adds another spots
a[1,1] = [9,8,7]  # => [1,9,8,7,"dog","cat",9] start at postion 1 and add 3 nums into 1 spot
a[0..3] = []      # => ["dog", "cat",9]   adds emtpy array into postions 0 through/including 3

# using array methods you can treat arrays as stacks, sets, queues, dequeues, and fifos


# HASHES

# hashes sometimes known as associative arrays or dictionaries
# while arrays indexed with integers, can index hash with objects of any type:
# strings, reg expressions, etc
# can create hash using hash literal with key value pairs between braces
h = { "dog" => "canine", "cat" => "feline", "donkey" => "asinine" }
h.length      # => 3
h["dog"]      # => "canine"
h["cow"] = "bovine"
h[12] = "dodecine"
h["cat"] = 99
h     # => { "cow" => "bovine", "cat" => 99, 12 => "dodecine", "donkey" => "asinine", "dog" => "canine" }

# hashes have advantage that can use any object as the index
# main disadvantage is that hash elements are not ordered
# so can not easily use them as a stack or queues
# still hashes most common used data structure in Ruby


# methods needed to implement the songlist jukebox demo example
# append(aSong) => append the given song to the list
# deleteFirst() => remove the first song from the list, returning the song
# deleteLast() => remove the last song from the list, returning the song
# [anIndex] => return the song identified by anIndex which may by an integer index or song title

# the ability to append songs to the end and remove from both the front and end
# suggests a dequeue -- a double ended queue

=end

class SongList
  def initialize
    @songs = Array.new
  end
end

class SongList
  def append(aSong)
    @songs.push(aSong)
    self
  end
end

class SongList
  def deleteFirst
    @songs.shift
  end
  def deleteLast
    @songs.pop
  end
end

list = SongList.new
append(Song.new("title1", "artist1", 1))
puts list

# our next method is [], which accesses elements by index. if the index is a number
# we just return the element at that postion
class SongList
  def [](key)
    if key.kind_of?(Integer)
      @songs[key]
    else
      for i in 0...@songs.length
        return @songs[i] if key == @songs[i].name
      end
    end
    return nil
  end
end

# we need to add the ability to look up song by title, which involves
# scanning through songs in list checking the title of each
# above is one solution using a for loop in the else portion of the if statement
# below is another option using an iterator
# here the find method, an iterator from the Enumerable class, replaces the for loop above
# it asks the array to apply a test to each of its members

class Songlist
  def [](key)
    if key.kind_of?(Integer)
      @songs[key]
    else
      result = @songs.find { |aSong| key == aSong.name }
    end
    return result
  end
end

# from above we can use and if statement modifer to shorten the code even more
class SongList
  def [](key)
    return @songs[key] if key.kind_of?(Integer)
    return @songs.find { |aSong| aSong.name == key }
  end
end


# IMPLEMENTING ITERATORS

# iterator is simply a method that can invoke a block of code
# a block in Ruby is a way of grouping statement but
# not in conventional way as we might see in Java, C, or Perl

# first, a block may appear only in the source adjacent to amethod call
# the block is written starting on the same line as the methods parameter
# second,  the code in the block is not executed at the time it is encountered
# instead Ruby remembers the context in which the block appears and then enters the method
# within the method, the block may be invoked almost as if it were a method itself
# whenever a yield is executed it invokes the code in the block,
# when the block exits, control picks back up immediatly after the yield



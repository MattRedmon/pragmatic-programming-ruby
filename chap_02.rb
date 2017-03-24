# CHAP 02 - CLASSES, OBJECTS, AND VARIALBES

=begin
class Song
  def initialize(name, artist, duration)
    @name     = name
    @artist   = artist
    @duration = duration
  end
end

# initialize special Ruby method
# when call Song.new Ruby creates uninitialized obj then calls initialize method
# sets up objects state

# each obj represents its own song, each song needs its own name, artist and duration
# values stores in instance variables within obj
# instance variable is preceded by @ symbol

aSong = Song.new("Holiday", "Madonna", 260)
aSong.inspect     # <Song:0x2636b20 @name="Holiday", @artist="Madonna", @duration=260>

class Song
  def to_s
    "Song: #{@name}--#{@artist}  (#{@duration})"
  end
end
puts aSong.to_s     # Song: Holiday--Madonna  (260)

# to_s normally changes something to a string
# but above we've over wrote that method in our song class
# and it now prints out our name, artist, and duration in the format we specified

# classes are never closed in Ruby so you can always add methods to and existing class
# this applies to classes you write as well as standard, built in classes
# we can add new methods to any class one at a time like above or
# if creating the code from scratch can put them all in one class definition


# INHERITANCE AND MESSAGES

# inheritance allows you to create a class that is a refinement or specialization of another class

class KaraokeSong < Song
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration)
    @lyrics = lyrics
  end
end

# KaraokeSong is a subclass of Song (so Song is a superclass, or parent of KaroakeSong)
# it inherits from Song

aSong = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the .....")
puts aSong.to_s    # Song: My Way--Sinatra  (225)
# our last line of code doesn't print the lyrics though! why??
# Ruby looks in KaraokeSong class first but does not find the to_s method
# it then looks a KaraokeSong's parent Song where it does find the to_s method
# but that method does not print out lyrics as it is defined
# we can fix this by implementing a KaraokeSong to_s method

# first the bad/wrong way to do it

class KaraokeSong

  def to_s
    "KS: #{@name}--#{@artist}  (#{@duration})  [#{@lyrics}]"
  end
end
puts aSong.to_s   #  KS: My Way--Sinatra  (225)  [And now, the .....]

# our new code now prints the lyrics as well

# above is bad because we are poking around in the parent classes internal state
# and tying ourselves tightly to its implementation
# we get around this problem by having each class handle its own internal state
# when KaraokeSong to_s is called we'll have it call it's parent's to_s method
# to get the song details then append to this the lyric info and return the result
# key is keyword "super" - when you invoke super with no args Ruby sends a messeage to the
# current objs parent asking it to invoke a method of the same name as the current method
# and passing it the params that were passed to the current method

# now better way to implement KaraokeSong to_s method
class KaraokeSong < Song
  # format ourselves as a string by appending
  # our lyrics to our parents' to_s value
  def to_s
    super + " [#{@lyrics}]"
  end
end
puts aSong.to_s    # Song: My Way--Sinatra  (225) [And now, the .....]
# the refactored code above now also prints the lyrics along with the name, artist, and duration


# INHERITANCE AND MIXINS

# some langs like C++ support multiple inheritance where class can have more than one parent
# which can be dangerous as child inherits from all parents and hierarchy can become ambigous

# other langs like Jave support only single inheritance which has less flexiblity
# since real world objs that we are modeling can inherit from multiple sources

# Ruby compromises -- has only single inheritance but can add other functionality through mixins
# which is like a partial class definition


# OBJECTS AND ATTRIBUTES

# so far the Song objs we've created have an internal state but it is private to those objects
# no other object can access the Song objects instance variables which we need to be albe to do
# to interact with the info stored in those variables

class Song
  def name
    @name
  end
  def artist
    @artist
  end
  def duration
    @duration
  end
end
# above we've defined three accessor methods to return the values of the three instance attributes
aSong = Song.new("My Way", "Sinatra", 260)
aSong.artist     # "Sinatra"
aSong.name       # "My Way"
aSong.duration   # 260

# because this is so common Ruby provides shortcut: attr_reader create these accessor methods for you

class Song
  attr_reader  :name,  :artist:, :duration
end
aSong.artist     # "Sinatra"
aSong.name       # "My Way"
aSong.duration   # 260

# construct :artist is an expression that returns a Symbol obj corresponding to the artist
# can think of :artist as meaning the name of the variable artist
# while plan artis is the value of the variable

# Sometimes you need to be able to set an attribute from outside the object
# would use setter function but Ruby provides shortcut for creating attribute setting methods

class Song
  attr_writer  :duration
end
aSong = Song.new("Alone", "Heart", 360)
aSong.duration = 345
puts aSong.duration    # 345

class Song
  def durationInMinutes
    @duration/60.0  # forces floating point
  end
  def durationInMinutes=(value)  # here equal is not setting equal to, it's part of the method name
    @duration = (value*60).to_i
  end
end
aSong = Song.new("Alone", "Heart", 260)
aSong.durationInMinutes                   # 4.333333
aSong.durationInMinutes = 4.2
aSong.durationInMinutes                   # 252

# we've uses attribute methods to create a virtual instance variable
# to outside world, durationInMinutes seems to be an attribute like any other
# Internally, however, there is no correpsonding isntance variable
# by hiding the difference between instance vars and calculated variable
# we are sheilding the rest of the world from the implementation of our class
# allows us to change things in future without impacting the lines of code that use our class

=end
# CLASS VARIABLE AND CLASS methods

# sometimes classes themselves need to have their own state
# a class variable is shared among all objs of a class
# there is only one copy of a particular class variable for a given class
# class variables start with two @ signs -> @@
# unlike global and instance vars, class vars must be initialized before they are used

# on our song/jukebox example, we may want to know how many songs have been played in total
# we could do this by searching for all the Song objs and adding up their songs played count
# or we could use a global variable (which is a very very bad thing)
# or we can use a class variable

class Song
  @@plays = 0
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
    @plays = 0
  end
  def play
    @plays += 1
    @@plays += 1
    "This song: #{@plays} plays. Total #{@@plays} plays."
  end
end
# for debugging purposes weve arrange for Song play to return a string containing # of times song played
s1 = Song.new("Song1", "Artist1", 234)
s2 = Song.new("Song2", "Artist2", 345)
puts s1.play    # This song: 1 plays. Total 1 plays.
puts s2.play    # This song: 1 plays. Total 2 plays.
puts s1.play    # This song: 2 plays. Total 3 plays.
puts s1.play    # This song: 3 plays. Total 4 plays.

# class variables are private to a class and its instances
# if you want to make them accessible to outside world wil need to write accessor methods

# sometimes a class needs to provide methods that work without being tied to any particular obj
# class methods distinguished from instance methods by thier definition
# Class methods are defined by placing the class name and a period in from of the method name

class Example
  def instance_method    # instance method
  end

  def Example.class_method    # class method
  end
end

# in our example, we may want to prevent songs that take to long to play as they are less profitable
# we could define a class method that checked to see if a particular song exceeded a certain limit
# we'll set the limit using a class constant

class SongList
  MaxTime = 5 * 60    # 5 minutes
  def SongList.isToLong(aSong)
    return aSong.duration > MaxTime
  end
end
song1 = Song.new("Songs1", "Artists1", 260)
puts SongList.isToLong(song1)               # false
song2 = Song.new("Songs2", "Artists2", 468)
puts SongList.isToLong(song2)               # true


# SINGLETONS AND OTHER CONSTUCTORS





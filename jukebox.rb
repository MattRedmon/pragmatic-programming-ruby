

class Song
  def initialize(name, artist, duration)
    @name     = name
    @artist   = artist
    @duration = duration
  end
end

class Song
  attr_reader  :name,  :artist:, :duration
end



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
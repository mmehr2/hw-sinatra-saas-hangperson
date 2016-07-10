class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  @@source = 'Unix, with web backup to Watchout4snakes.com' # "Unix" or website URL domain
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    self
  end
  
  def guess(letter)
    raise ArgumentError, "Invalid guess #{letter}" if letter == nil || letter.empty? || !(letter =~ /^[a-z]$/i)
    letter.downcase!
    valid = true
    if @word.include? letter
      valid = ! (@guesses.include? letter)
      @guesses << letter if valid 
    else
      valid = ! (@wrong_guesses.include? letter)
      @wrong_guesses << letter if valid
    end
    valid
  end
  
  def word_with_guesses
    @word.gsub(/(.)/) { |x| @guesses.include?(x) ? x : '-' }
  end
  
  def check_win_or_lose
    if !(word_with_guesses.include? '-')
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  def self.get_random_word
    self.get_random_word_local || self.get_random_word_remote
  end
  
  def source
    @@source
  end
  
  def self.source
    @@source
  end
  
 #private
  def self.get_random_word_remote
    #@@source = 'Watchout4snakes.com'
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def self.get_random_word_local dbg=false
    begin
      # NOTE: this will raise an exception if the file can't be found or opened
      @@source = 'step1'
      arr = IO.readlines('/usr/share/dict/words')
      @@source = 'step2'
      if arr.length > 1000
        # NOTE: the full file should be well over 10k words, but we'll test for 1k for sanity
        # return a random word from the file, but only if it doesn't have invalid characters
        # (most words have possessive forms with 's on the end)
        # we also want to skip proper names that start with upper case (so only accept lower case letters)
        # finally we want at least a few letters in the word but not too many (minimum 5 for now, max 20)
        # we assume that this search will terminate eventually (and quickly!)
        @@source = 'Unix'
        word = arr[rand(arr.length)].chomp until word =~ /^[a-z]{5,20}$/
        if dbg
          puts "Debug GRWL: word=#{word} len=#{word.length}"
        end
        word
      else
        nil
      end
    rescue
      nil
    end
  end

end

def testRWL(iters)
  cycles = 0
  cycles_bad = 0
  iters.times do
    word = HangpersonGame.get_random_word_local true
    if !word
      puts HangpersonGame.source
      return nil
    end
    ++cycles
    if word.length < 5 
      printf 'L'
      ++cycles_bad
    elsif word.length > 20
      printf 'H'
      ++cycles_bad
    end
  end
  puts; puts "Got #{cycles} words, #{cycles_bad} bad"
end

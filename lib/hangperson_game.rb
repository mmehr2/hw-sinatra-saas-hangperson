class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    self
  end
  
  def guess(letter)
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

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end

require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    flash[:message] = ''
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      if !@game.guess(letter)
        # bad guess happened - could be repeated if it is in guesses or wrong_guesses
        if @game.guesses.include?(letter) || @game.wrong_guesses.include?(letter)
          flash[:message] = "You have already used that letter."
        else
          flash[:message] = "Invalid guess."
        end
      end
    rescue
      # non-alphabetic or empty letters raise ArgumentError with an error message saved in $!
      flash[:message] = "Error: " + $!.to_s + ". Please enter an alphabetic character A-Z."
    end
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    case @game.check_win_or_lose
      when :win
        redirect '/win'
      when :lose
        redirect '/lose'
    end
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    # protect against directly using the url
    if @game.check_win_or_lose != :win
      flash[:message] = "Caught you! No cheating!"
      redirect '/show'
    end
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    # protect against directly using the url
    if @game.check_win_or_lose != :lose
      flash[:message] = "Don't worry, you haven't lost yet! Keep up the good work!"
      redirect '/show'
    end
    erb :lose # You may change/remove this line
  end
  
end

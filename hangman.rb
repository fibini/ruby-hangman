require 'ruby2d'

set title: "Hangman"
set background: 'white'


class Hangman
  def initialize
    @word = select_word
    @incorrect_guesses = []
    @correct_guesses = []
    @max_guesses = 6
    @game_over = false
  end

  def select_word
    words = ["ruby", "hangman", "games", "programming", "openai"]
    words.sample
  end

  # def play
  #   handle_key_press(event)
  # end

  def handle_key_press(event)
    guess = event.key.downcase

    if valid_guess?(guess) && !@game_over
      if @word.include?(guess)
        @correct_guesses << guess
        if won?
          @game_over = true
        end
      else
        @incorrect_guesses << guess
        if lost?
          @game_over = true
        end
      end
    end
  end

  def valid_guess?(guess)
    guess.length == 1 && guess.match?(/[a-z]/) && !(@correct_guesses.include?(guess) || @incorrect_guesses.include?(guess))
  end

  def won?
    visible_word == @word
  end

  def lost?
    @incorrect_guesses.length >= @max_guesses
  end

  def visible_word
    visible = ""
    @word.chars.each do |char|
      visible << (@correct_guesses.include?(char) ? char : "_")
    end
    visible
  end

  def display_board
    hint = ""
    if @word == "ruby"
      hint = "computer language"
      elsif
        @word == "hangman"
        hint = "swinging male"
      elsif
        @word == "games"
        hint = "what we play"
      elsif
        @word == "programming"
        hint = "make the computer speak"
      else
        @word == 'openai'
        hint = "artificial intelligence"
    end
    Text.new(visible_word, color: 'blue', x: 10, y: 10, size: 50)
    Text.new("Incorrect Guesses: #{@incorrect_guesses}", color:'black', x: 10, y: 100)
    Text.new("Guesses Remaining: #{guesses_remaining}", color:'black', x: 10, y: 130)
    Text.new("A hint: #{hint}", color: 'blue', x: 10, y: 160)
  end

  def display_game_over
    if lost?
      Text.new("GAME OVER", color:'red', x: 200, y: 100, size: 60)
      Text.new("The word was: #{@word}", color:'black', x: 220, y: 200, size: 30)
      Text.new(message, color:'black', x: 220, y: 300, size: 30)
    else
      Text.new("YOU WON, CONGRATS", color: 'blue', x: 80, y: 100, size: 60)
      Text.new(message, color:'black', x: 250, y: 300, size: 30)
    end
  end


  def guesses_remaining
    @max_guesses - @incorrect_guesses.length
  end

  def game_over
    @game_over
  end

  def message
    "Press 'spacebar' to restart"
  end
end

set width: 800, height: 600

game = Hangman.new

on :key_down do |event|
  game.handle_key_press(event)
  if event.key == 'space'
    game = Hangman.new
  end
end

update do
  clear
  if game.game_over
    game.display_game_over
  else
    game.display_board
  end
end

show
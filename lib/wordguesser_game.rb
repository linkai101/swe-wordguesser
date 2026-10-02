class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  MAX_WRONG_GUESSES = 7

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Processes a guess. Returns false if the letter was already guessed,
  # true otherwise. Raises ArgumentError for nil, empty or non-letter input.
  def guess(letter)
    raise ArgumentError, 'guess must be a letter' unless letter.is_a?(String) && letter.match?(/\A[a-z]\z/i)

    letter = letter.downcase
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.downcase.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    true
  end

  # Returns the word with unguessed letters replaced by '-'
  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c.downcase) ? c : '-' }.join
  end

  # Returns :win, :lose or :play
  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= MAX_WRONG_GUESSES

    :play
  end

  # Get a word from remote "random word" service
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      return http.post(uri, "").body
    end
  end
end

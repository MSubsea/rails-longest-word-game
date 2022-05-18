require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    if !english_word?(params[:solution])
      @scoreText = "This is not an english word"
    elsif !valid_grid?(params[:solution].upcase, params[:letters].split(""))
      @scoreText = "This is not in the grid"
    else
      @scoreText = "Congrats, you made it"
    end
  end

  def english_word?(attempt)
    w_url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    exists_raw = URI.open(w_url).read
    exists_json = JSON.parse(exists_raw)
    return exists_json["found"]
  end

  def get_hash(letter_list)
    letter_h = {}
    letter_list.each do |letter|
      letter_h[letter] = 0 unless letter_h.key?(letter)
      letter_h[letter] += 1
    end
    return letter_h
  end

  def valid_grid?(attempt, grid)
    ret = true
    att_list = attempt.upcase.chars.sort
    grid_list = grid.sort
    att_h = get_hash(att_list)
    grid_h = get_hash(grid_list)
    att_h.keys.each do |key|
      ret = false unless grid_h.key?(key) && att_h[key] <= grid_h[key]
    end
    return ret
  end
end

require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def home
  end

  def new
    @letters = generate_grid(params[:size].to_i)
  end

  def score
    @result = if word_exists?(params[:word]) && word_in_grid(params[:word], params[:odioso].chars)
                "Congrulations! #{params[:word]} is a valid English Word!"
              elsif !word_exists?(params[:word])
                'Not an English Word!'
              else
                'Not in the grid!'
              end
  end
end

def generate_grid(grid_size)
  letters = ('A'..'Z').to_a
  grid = []
  count = 0
  while count != grid_size
    index = rand(0..25)
    grid.push(letters[index])
    count += 1
  end
  return grid
end

def word_exists?(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  url_ = URI.open(url).read
  json_response = JSON.parse(url_)
  return json_response['found']
end

def word_in_grid(word, grid)
  word.upcase.chars do |char|
    if grid.include?(char)
      index = grid.index(char)
      grid.delete_at(index)
    else
      return false
    end
  end
  return true
end

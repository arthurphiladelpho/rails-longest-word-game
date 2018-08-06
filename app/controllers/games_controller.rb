require 'open-uri'
require 'nokogiri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      character = ("A".."Z").to_a[rand(26)]
      @letters << character
    end
    @letters
  end

  def score
    # TODO: runs the game and return detailed hash of result
    def run_game(attempt, grid, start, ending)
      attempt_chars = attempt.upcase.split("")
      file = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
      result = JSON.parse(Nokogiri::HTML(file).search('p').text)
      return { score: 0, message: "not an english word", time: 0 } unless result["found"]
      if result["found"]
        attempt_chars.each do |character|
          if grid.include? character
            grid.delete(character)
          else
            return { score: 0, message: "not in the grid", time: (ending - start) }
          end
        end
      end
      return {
        score: ((attempt_chars.length**2) + ((ending - start))),
        message: "well done",
        time: (ending - start)
      }
    end
    @word = params[:word]
    @grid = params[:grid]
    @start = params[:start].to_i
    @ending = (Time.now).to_i
    result = run_game(@word, @grid, @start, @ending)
    @message = result[:message]
    @score = result[:score]
    @time = result[:time]
  end
end

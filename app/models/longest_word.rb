require 'open-uri'
require 'json'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  grid_array = []
  grid_size.times do
    grid_array.push(("A".."Z").to_a.sample)
  end
  return grid_array
end

# Method to check if the word is inside of the grid
def check_the_grid(attempt, grid)
  attempt_array = attempt.upcase.split("")
  my_boolean = true
  attempt_array.each do |letter|
    if grid.map(&:upcase).include?(letter)
      grid.delete_at(grid.index(letter))
      my_boolean = true
    else
      my_boolean = false
      break
    end
  end
  return my_boolean
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  # acces the dictionary api
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  game_serialized = open(url).read
  game = JSON.parse(game_serialized)
  time = end_time - start_time
  # Check if the attempt word is an actual englisch word
  if game["found"]
    # Check if the word is containing all the words given in the grid (remember you can only use each letter once)
    if check_the_grid(attempt, grid)
      # Score depends on the time taken to answer, plus the length of the word you submit -> the shorter
      # the time and the longer the word the higher the score
      # Return a hash of all results
      # return result
      return { time: time, score: (100 - time) / 10 + game["length"].to_i, message: "You won! Well done!" }
    else
      return { time: time, score: 0, message: "well done, but your word is not in the grid" }
    end
  # If word is not valid or not in the grid return 0
  else
    return { time: time, score: 0, message: "your word is not an english word" }
  end
end

# p generate_grid(9)
# puts run_game("book", ["k", "o", "b", "o", "k"], 2, 5)

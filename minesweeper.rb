require './tile'
require './board'
require 'yaml'

class Minesweeper

  def initialize(rows = 9, cols = 9, bombs = 10)
    @board = Board.new(rows, cols, bombs)
    @previous_duration = 0
    @start_time = nil
  end

  def run
    @start_time = Time.now
    action = nil
    until action == :save || @board.over?
      @board.show
      action = process_user_input(get_user_input)
    end
    @board.show
    if @board.won?
      puts "You won!"
      puts "It took you #{duration + @previous_duration} seconds"
    elsif @board.lost?
      puts "BOMB! You lose"
    else
      puts "Saved your game"
    end
  end

  def process_user_input(user_input)
    case user_input[0]
    when "r"
      @board[user_input.drop(1)].reveal
    when "f"
      @board[user_input.drop(1)].flagged = true
    when :save
      @previous_duration += duration
      File.open("minesweeper.yml", "w") do |f|
        f.puts self.to_yaml
      end
      :save
    end
  end

  def get_user_input

    begin
      puts "What's your move?"
      user_input = gets.chomp.downcase
      if user_input == "save"
        return [:save]
      end
      input_arr = user_input.split(",")

      if input_arr.length == 3
        p input_arr
        input_arr[1], input_arr[2] = input_arr[1].to_i, input_arr[2].to_i
        raise "Your coordinates are out of bound" unless in_bounds?(input_arr.drop(1))
        unless input_arr[0] == "r" or input_arr[0] == "f"
          raise "Your action should be either r or f"
        end
      else
        raise "Invalid input!"
      end

    rescue => e
      p e.message
      puts "Input in this format: r,1,1"
      retry
    end

    input_arr

  end

  def in_bounds?(pos)
    pos[0].between?(0, @board.rows-1) && pos[1].between?(0, @board.cols-1)
  end

  def duration
    Time.now - @start_time
  end

end

if __FILE__ == $PROGRAM_NAME
  puts "New game? or load old game?"
  choice = gets.chomp.downcase
  if choice == "load"
    if File.exist?("minesweeper.yml")
      game = YAML.load(File.open("minesweeper.yml"))
      game.run
    else
      choice = "new"
    end
  end

  if choice == "new"
    puts "easy, medium, or hard?"
    case gets.chomp.downcase
    when "easy"
      Minesweeper.new(8, 8, 10).run
    when "medium"
      Minesweeper.new(16, 16, 40).run
    when "hard"
      Minesweeper.new(32, 32, 80).run
    end
  end
end

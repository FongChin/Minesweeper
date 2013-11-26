require './tile'
require './board'

class Minesweeper

  def initialize(rows = 9, cols = 9, bombs = 10)
    @board = Board.new(rows, cols, bombs)
  end

  def run
    until @board.over?
      @board.show
      process_user_input(get_user_input)
    end
    @board.show
    if @board.won?
      puts "You won!"
    elsif @board.lost?
      puts "BOMB! You lose"
    end


  end

  def process_user_input(user_input)
    case user_input[0]
    when "r"
      @board[user_input.drop(1)].reveal
    when "f"
      @board[user_input.drop(1)].flagged = true
    end
  end


  def get_user_input

    begin
      puts "What's your move?"
      input_arr = gets.chomp.split(",")

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

end

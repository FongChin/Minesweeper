class Board

  attr_accessor :rows, :cols, :bombs

  def initialize(rows = 9, cols = 9, bombs = 10)
    @bombs = bombs
    @rows = rows
    @cols = cols
    @tiles = Array.new(rows) { Array.new(cols) }
    create_board
  end

  def create_board
    (0...@rows).each do |row|
      (0...@cols).each do |col|
        self[[row, col]] = Tile.new([row, col], self)
      end
    end
    place_bomb

    nil
  end

  def [](pos)
    self.tiles[ pos[0]][pos[1] ]
  end

  def place_bomb
    bombs_placed = 0
    until bombs_placed == @bombs
      current_tile = self[[rand(9), rand(9)]]
      next if current_tile.bombed?
      current_tile.bombed = true
      bombs_placed += 1
    end
  end

  def show

  end

end
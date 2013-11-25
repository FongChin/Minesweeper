class Board

  attr_accessor :rows, :cols, :bombs, :tiles

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
    @tiles[pos[0]][pos[1]]
  end

  def []=(pos, tile)
    @tiles[ pos[0]][pos[1] ] = tile
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
    @tiles.each do |row|
      p row
    end
  end

  def over?
    lost? || won?
  end

  def lost?
    @tiles.each do |row|
      row.each do |tile|
        return true if tile.revealed? && tile.bombed?
      end
    end
    false
  end

  def won?
    unrevealed_tiles = 0
    @tiles.each do |row|
      row.each do |tile|
        unrevealed_tiles += 1 unless tile.revealed?
        return false if unrevealed_tiles > @bombs
      end
    end
    true
  end

end

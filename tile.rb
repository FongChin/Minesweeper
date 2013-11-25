class Tile

  attr_accessor :bombed, :flagged, :revealed, :bomb_count
  attr_reader :position, :board

  def initialize(position, board)
    @position = position
    @board = board
    @bombed, @flagged, @revealed, @bomb_count = false, false, false, nil
  end

  def bombed?
    @bombed
  end

  def flagged?
    @flagged
  end

  def revealed?
    @revealed
  end

  def neighbors
    diffs = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

    diffs.map {|diff| [@position[0] + diff[0], @position[1] + diff[1]] }
  end

  def neighbor_bomb_count
    count = 0
    self.neighbors.each do |neighbor|
      count += 1 if @board[neighbor].bombed?
    end
    count
  end

  def reveal
    self.revealed = true

    if self.neighbor_bomb_count(@board) > 0
      self.bomb_count = self.neighbor_bomb_count(@board)
      return self
    end

    self.neighbors.each do |neighbor|
      #board.tiles.length rows
      rows = @board.rows
      cols = @board.cols


      #check for if bounds: if yes do next line, else NEXT
      #NEXT if tile is already revealed
      @board[neighbor].reveal
    end
  end

  def to_s
    #if its not revealed
    #if it has abomb coutn
    #return # of bombs
  end
end
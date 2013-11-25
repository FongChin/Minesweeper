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
    return self if self.flagged?

    self.revealed = true

    if self.neighbor_bomb_count(@board) > 0
      self.bomb_count = self.neighbor_bomb_count(@board)
      return self
    end

    self.neighbors.each do |neighbor|
      rows = @board.rows
      cols = @board.cols
      next unless neighbor[0].between?(0, rows) && neighbor[1].between?(0, cols)
      next if @board[neighbor].revealed?
      @board[neighbor].reveal
    end
  end

  def to_s
    if not revealed?
      "*"
    elsif @flagged
      "F"
    elsif @bomb_count == 0
      "_"
    else
      "#{@bomb_count}"
    end
  end
end
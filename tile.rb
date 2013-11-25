class Tile

  attr_accessor :bombed, :flagged, :revealed, :bomb_count
  attr_reader :position, :board

  DIFFS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

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
    neighbors = DIFFS.map do |diff|
      [@position[0] + diff[0], @position[1] + diff[1]]
    end
    neighbors.select { |neighbor| in_bounds?(neighbor) }
  end

  def neighbor_bomb_count
    count = 0
    neighbors.each do |neighbor|
      count += 1 if @board[neighbor].bombed?
    end
    count
  end

  def reveal
    return self if self.flagged?

    @revealed = true
    @bomb_count = neighbor_bomb_count

    if @bomb_count > 0
      return self
    end

    neighbors.each do |neighbor|
      next if @board[neighbor].revealed?
      @board[neighbor].reveal
    end
  end

  def in_bounds?(pos)
    pos[0].between?(0, @board.rows-1) && pos[1].between?(0, @board.cols-1)
  end

  def to_s
    if not revealed?
      "*"
    elsif @flagged
      "F"
    elsif @bomb_count == 0 || @bomb_count.nil?
      "_"
    elsif bombed?
      "B"
    else
      "#{@bomb_count}"
    end
  end
end
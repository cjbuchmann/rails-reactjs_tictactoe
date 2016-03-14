class Board
  include ActiveModel::Model

  class InvalidMoveError < StandardError; end
  class InvalidLoadError < StandardError; end
  class InvalidPlayerError < StandardError; end

  validates :player_one, presence: true
  validates :player_two, presence: true
  validates :size, presence: true, numericality: true

  attr_accessor :board, :player_one, :player_two, :size, :current_player_turn

  def build
    self.size = self.size.to_i

    unless self.current_player_turn
      self.current_player_turn = [self.player_one, self.player_two].sample
    end

    @board = []
    self.size.times do
      row = []
      self.size.times do
        row << nil
      end
      @board << row
    end

    self
  end

  def add_move(move)
    if self.current_player_turn != move.player
      raise InvalidPlayerError
    end

    move.x_pos = move.x_pos.to_i
    move.y_pos = move.y_pos.to_i

    if valid_move?(move)
      @board[move.x_pos][move.y_pos] = move
      self.current_player_turn = next_player
    else
      raise InvalidMoveError
    end
  end

  def has_won?(player)
    @board.each_with_index do |row, i|
      row.each_with_index do |col, j|
        position = @board[i][j]
        break if position.blank? || position.player != player
        return true if j+1 == @board.size
      end

      row.each_with_index do |col, j|
        position = @board[j][i]
        break if position.blank? || position.player != player
        return true if j+1 == @board.size
      end
    end

    @board.each_with_index do |row, i|
      position = @board[i][i]
      break if position.blank? || position.player != player
      return true if i+1 == @board.size
    end

    @board.each_with_index do |row, i|
      position = @board[@board.size-1 - i][i]
      break if position.blank? || position.player != player
      return true if i+1 == @board.size
    end

    false
  end

  # we don't want to persist the object in memory, just the data,
  # so we'll load up the object here
  def self.load(serial)
    board = Board.new(serial.except('winner').merge({size: serial['board'].size}))
    raise InvalidLoadError unless board.valid?

    moves = []
    serial['board'].each_with_index do |row, i|
      row = []
      serial['board'][i].each_with_index do |col, j|
        if serial['board'][i][j].present?
          row << Move.new( serial['board'][i][j] )
        else
          row << nil
        end
      end
      moves << row
    end
    board.board = moves

    return board
  end

  def as_json(options={})
    winner = nil

    [self.player_one, self.player_two].each do |player|
      if has_won? player
        winner = player
        break
      end
    end

    {
      board: @board.as_json,
      player_one: self.player_one,
      player_two: self.player_two,
      current_player_turn: self.current_player_turn,
      winner: winner
    }
  end

  private

  def valid_move?(move)
    @board[move.x_pos][move.y_pos].blank?
  end

  def next_player
    if self.current_player_turn == self.player_one
      return self.player_two
    end
    self.player_one
  end
end

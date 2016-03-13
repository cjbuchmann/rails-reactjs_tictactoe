class Board
  include ActiveModel::Model

  class InvalidMoveError < StandardError; end

  attr_accessor :board

  def initialize(board_size)
    @board = []
    board_size.times do
      row = []
      board_size.times do
        row << nil
      end
      @board << row
    end

    self
  end

  def add_move(move)
    move.x_pos = move.x_pos.to_i
    move.y_pos = move.y_pos.to_i

    if valid_move?(move)
      @board[move.x_pos][move.y_pos] = move
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

  def find_players
    players = {}
    @board.each_with_index do |row, i|
      row.each_with_index do |col, j|
        players[col.player] = col.player if col
      end
    end

    players.keys
  end

  # we don't want to persist the object in memory, just the data,
  # so we'll load up the object here
  def self.load(serial)
    board = Board.new(serial[:board].size)
    moves = []
    serial[:board].each_with_index do |row, i|
      row = []
      serial[:board][i].each_with_index do |col, j|
        if serial[:board][i][j].present?
          row << Move.new( serial[:board][i][j] )
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
    find_players.each do |player|
      if has_won?(player)
        winner = player
        break
      end
    end


    {
      board: @board.as_json,
      winner: winner
    }
  end

  private

  def valid_move?(move)
    puts "move is #{move.inspect}"
    @board[move.x_pos][move.y_pos].blank?
  end
end

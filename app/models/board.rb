class Board
  include ActiveModel::Model

  class InvalidMoveError < StandardError; end

  attr_accessor :board_moves

  def initialize(board_size)
    @board_moves = []
    board_size.times do
      @board_moves << [nil,nil,nil]
    end

    self
  end

  def add_move(move)
    if valid_move?(move)
      @board_moves[move.x_pos][move.y_pos] = move
    else
      puts "invalid move #{move.inspect}"
      raise InvalidMoveError
    end
  end

  def has_won?(player)
    @board_moves.each_with_index do |row, i|
      row.each_with_index do |col, j|
        position = @board_moves[i][j]
        break if position.blank? || position.player != player
        return true if j+1 == @board_moves.size
      end

      row.each_with_index do |col, j|
        position = @board_moves[j][i]
        break if position.blank? || position.player != player
        return true if j+1 == @board_moves.size
      end
    end

    @board_moves.each_with_index do |row, i|
      position = @board_moves[i][i]
      break if position.blank? || position.player != player
      return true if i+1 == @board_moves.size
    end

    @board_moves.each_with_index do |row, i|
      position = @board_moves[@board_moves.size-1 - i][i]
      break if position.blank? || position.player != player
      return true if i+1 == @board_moves.size
    end

    false
  end

  private

  def valid_move?(move)
    @board_moves[move.x_pos][move.y_pos].blank?
  end
end

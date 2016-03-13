class Api::V1::MoveController < Api::BaseController

  def create
    board = Board.load( Persistance::fetch(:board) )

    raise BoardNotFoundError if board.blank?

    move = Move.new( permitted_params )

    if move.valid?
      begin
        board.add_move(move)

        Persistance::persist(:board, board.as_json )

        winner = board.has_won?(move.player) ? move.player : nil
        render json: { move: move, winner: winner }, status: :created
      rescue Board::InvalidMoveError
        render json: { errors: ['Illegal board move'] }, status: :bad_request
      end
    else
      render json: { errors: move.errors }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.require(:move).permit(:x_pos, :y_pos, :player)
  end
end

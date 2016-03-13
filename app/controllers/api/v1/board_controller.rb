class Api::V1::BoardController < Api::BaseController

  def index
    render json: Board.load(Persistance::fetch(:board))
  end

  def create
    board_size = params[:board].present? ? params[:board][:size].to_i : 3
    board = Board.new(board_size)
    Persistance::persist(:board, board.as_json )

    render json: board, status: :created
  end
end

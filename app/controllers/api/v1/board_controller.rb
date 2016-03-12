class Api::V1::BoardController < Api::BaseController

  def index
    render json: Persistance::fetch(:board)
  end

  def create
    Persistance::persist(:board, Board.new(board_size=3) )

    render json: Persistance::fetch(:board), status: :created
  end
end

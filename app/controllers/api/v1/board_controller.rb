class Api::V1::BoardController < Api::BaseController

  def index
    if session[:board]
      render json: Board.load(session[:board])
    else
      render nothing: true, status: :not_found
    end
  end

  def create
    board_size = params[:board].present? ? params[:board][:size].to_i : 3
    board = Board.new( permitted_params )

    if board.valid?
      board.build
      session[:board] = board.as_json
      render json: board, status: :created
    else
      render json: { errors: board.errors }, status: :bad_request
    end

  end

  def permitted_params
    params.require(:board).permit(:size, :player_one, :player_two)
  end
end

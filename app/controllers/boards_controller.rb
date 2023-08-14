class BoardsController < ApplicationController
  def new
    @board = Board.new
  end

  def edit
    authorize board
  end

  def show
    authorize board
  end

  def update
    authorize board

    if board.update(board_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    authorize board
    board.destroy
    redirect_to root_path
  end

  def create
    @board = Board.new(board_params.merge(user: current_user))

    if @board.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def board
    @board ||= Board.find(params[:id])
  end
end

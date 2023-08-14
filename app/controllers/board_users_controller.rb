class BoardUsersController < ApplicationController
  def new
    @board_user = board.board_users.new
  end

  def create
    board_user_ids = board.members.where.not(id: board.user_id).ids

    user_ids_to_destroy = board_user_ids - user_ids

    BoardUser.where(board: board, user_id: user_ids_to_destroy).delete_all
    users_to_assign = User.where(id: user_ids).where.not(id: board.reload.members.ids)
    board.members << users_to_assign
    redirect_to board_path(board)
  end

  private

  def user_ids
    params[:user_ids].map(&:to_i).reject(&:zero?)
  end

  def board
    @board ||= Board.find(params[:board_id])
  end
end

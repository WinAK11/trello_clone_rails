module Api
  class ListsController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      @lists = board.lists.order(position: :asc)
      render json: ListSerializer.new(@lists).serializable_hash
    end

    private

    def board
      @board ||= Board.find(params[:board_id])
    end
  end
end

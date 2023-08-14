module Api
  class ListPositionsController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      @lists = board.lists.order(position: :asc)
      render json: ListSerializer.new(@lists).serializable_hash
    end

    def update
      lists = board.lists.to_a
      delete_index = lists.index { |list| list.id == params[:id].to_i }
      list = lists.delete_at(delete_index)
      lists.insert(params[:position].to_i, list)
      lists.each_with_index do |l, index|
        l.position = index
      end

      List.import lists, on_duplicate_key_update: { conflict_target: [:id], columns: [:position] }

      render json: ListSerializer.new(lists).serializable_hash.to_json
    end

    private

    def board
      @board ||= Board.find(params[:board_id])
    end
  end
end

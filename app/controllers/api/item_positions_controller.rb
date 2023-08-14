module Api
  class ItemPositionsController < ApplicationController
    protect_from_forgery with: :null_session

    def update
      items = items_params[:items].map do |item_data|
        item = Item.find(item_data[:id])
        item.position = item_data[:position]
        item.list_id = item_data[:list_id]
        item
      end

      Item.import items, on_duplicate_key_update: { conflict_target: [:id], columns: [:position, :list_id] }
      render json: ItemSerializer.new(items).serializable_hash.to_json
    end

    private

    def items_params
      params.permit(items: [:id, :position, :list_id])
    end
  end
end

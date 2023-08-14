module Api
  class ItemsController < ApplicationController
    protect_from_forgery with: :null_session

    def show
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item).serializable_hash.to_json
    end
  end
end

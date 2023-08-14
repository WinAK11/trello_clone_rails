class ItemMembersController < ApplicationController
  def new
    item
  end

  def create
    item_user_ids = item.members.ids

    user_ids_to_destroy = item_user_ids - user_ids

    ItemMember.where(item: item, user_id: user_ids_to_destroy).delete_all
    users_to_assign = User.where(id: user_ids).where.not(id: item.reload.members.ids)
    item.members << users_to_assign
    redirect_to board_path(item.list.board)
  end

  private

  def user_ids
    params[:user_ids].map(&:to_i).reject(&:zero?)
  end

  def item
    @item ||= Item.find(params[:item_id])
  end
end

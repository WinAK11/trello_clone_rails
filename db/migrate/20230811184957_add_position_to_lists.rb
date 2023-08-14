class AddPositionToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :position, :integer, null: false, default: 0
  end
end

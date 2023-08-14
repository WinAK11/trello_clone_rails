class RemoveClassListFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :class_list
  end
end

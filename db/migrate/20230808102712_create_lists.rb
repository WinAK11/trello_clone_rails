class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.references :board, null: false, foreign_key: true
      t.string :title
      t.string :class_list

      t.timestamps
    end
  end
end

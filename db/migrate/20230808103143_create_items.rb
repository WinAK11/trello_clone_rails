class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :list, null: false, foreign_key: true
      t.string :title
      t.string :class_list

      t.timestamps
    end
  end
end

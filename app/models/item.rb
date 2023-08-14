class Item < ApplicationRecord
  belongs_to :list
  validates :title, presence: true

  has_many :item_members, dependent: :destroy
  has_many :members, through: :item_members, source: :user
end

class List < ApplicationRecord
  belongs_to :board

  validates :title, presence: true

  has_many :items, dependent: :destroy
end

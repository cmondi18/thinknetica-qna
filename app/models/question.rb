class Question < ApplicationRecord
  has_many :answer, dependent: :destroy

  validates :title, :body, presence: true
end

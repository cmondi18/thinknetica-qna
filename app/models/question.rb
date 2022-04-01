class Question < ApplicationRecord
  validates :title, :body, presence: true

  has_many :answer
end

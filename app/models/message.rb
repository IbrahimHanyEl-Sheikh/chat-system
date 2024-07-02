class Message < ApplicationRecord
  belongs_to :chat

  validates :number, presence: true, numericality: { only_integer: true }
  validates :body, presence: true

  validates_associated :chat
end

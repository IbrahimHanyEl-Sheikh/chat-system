class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, presence: true, numericality: { only_integer: true }
  validates :messages_count, numericality: { only_integer: true }

  validates_associated :application

end

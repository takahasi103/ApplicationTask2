class Room < ApplicationRecord
  #DM
  has_many :entries, dependent: :destroy
  has_many :direct_messages, dependent: :destroy
end

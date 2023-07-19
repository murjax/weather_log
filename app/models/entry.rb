class Entry < ApplicationRecord
  validates :temperature, presence: true
  validates :humidity, presence: true
end

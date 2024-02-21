# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :room_users, dependent: :destroy
  has_many :members, class_name: 'User', through: :room_users, dependent: :destroy

  belongs_to :owner, class_name: 'User', optional: true

  validates :name, presence: true, uniqueness: true
end

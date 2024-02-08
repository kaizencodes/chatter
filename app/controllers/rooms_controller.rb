# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show]

  def show; end

  private

  def set_room
    @room = Room.first
  end
end

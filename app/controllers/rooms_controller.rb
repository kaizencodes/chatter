# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show]

  def index
    @rooms = Room.all
  end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name)
  end
end

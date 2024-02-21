# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show add_member]
  before_action :authorize_member, only: %i[show]

  def index
    @rooms = Room.left_joins(:members).where(owner: current_user).or(Room.left_joins(:members).where(owner: nil))
              .or(Room.left_joins(:members).where('room_users.user_id = ?', current_user.id))
  end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params.except(:private))

    if room_params[:private] == '1'
      @room.owner = current_user
    end

    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def add_member
    user = User.find(params[:room][:user_id])
    @room.members << user
    @room.save

    redirect_to @room, notice: 'You have joined the room.'
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :private)
  end

  def authorize_member
    return if @room.owner.nil?
    return if @room.owner == current_user
    return if @room.members.include?(current_user)

    redirect_to rooms_url, alert: 'You are not allowed here'
  end
end

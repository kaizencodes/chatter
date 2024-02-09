# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[edit update destroy]
  before_action :set_room

  def edit; end

  def create
    @message = @room.messages.new(message_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @message.save
        format.html { redirect_to @room }
      else
        format.html { redirect_to @room, alert: @message.errors.full_messages.join(', ') }
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @room }
      else
        format.html { render :edit, alert: @message.errors.full_messages.join(', ') }
      end
    end
  end

  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to @room }
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def set_message
    @message = Message.find_by(id: params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end

# frozen_string_literal: true

module MessagesHelper
  def message_belongs_to_current_user?(message)
    message.user_id == current_user.id
  end
end

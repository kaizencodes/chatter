# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/edit', type: :view do
  it 'renders the edit message form' do
    message = create(:message)
    assign(:message, message)

    render

    assert_select 'form[action=?][method=?]', message_path(message), 'post' do
      assert_select 'textarea[name=?]', 'message[content]'
    end
  end
end

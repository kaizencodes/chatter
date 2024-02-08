# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new', type: :view do
  it 'renders new message form' do
    message = build(:message)
    assign(:message, message)

    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'textarea[name=?]', 'message[content]'
    end
  end
end

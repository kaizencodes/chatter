# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/edit', type: :view do
  let(:room) { create(:room, name: 'Room 1') }
  let(:message) { create(:message, room:, content: 'Hello, world!') }

  before(:each) do
    assign(:room, room)
    assign(:message, message)
  end

  xit 'renders the messages' do
    render
    expect(rendered).to match(/Hello, world!/)
  end

  xit 'renders the edit message form' do
    render

    assert_select 'form[action=?][method=?]', room_message_path(room, message), 'post' do
      assert_select 'textarea[name=?]', 'message[content]'
    end
  end
end

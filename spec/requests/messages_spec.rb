# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/rooms/room_id/messages', type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  before do
    sign_in user
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      message = create(:message, room:)
      get edit_room_message_url(room, message)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(message.content)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Message' do
        expect do
          post room_messages_url(room), params: { message: attributes_for(:message) }
        end.to change(room.messages, :count).by(1)
      end

      it 'redirects to the room page' do
        post room_messages_url(room), params: { message: attributes_for(:message) }
        expect(response).to redirect_to(room_url(room))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Message' do
        expect do
          post room_messages_url(room), params: { message: { foo: 'bar' } }
        end.to change(room.messages, :count).by(0)
      end

      it 'redirects to the room page' do
        post room_messages_url(room), params: { message: attributes_for(:message) }
        expect(response).to redirect_to(room_url(room))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested message' do
        message = create(:message, content: 'original content', room:)

        patch room_message_url(room, message), params: { message: { content: 'new content' } }

        message.reload
        expect(message.content).to eq 'new content'
      end

      it 'redirects to the room page' do
        message = create(:message, content: 'original content')

        patch room_message_url(room, message), params: { message: { content: 'new content' } }

        expect(response).to redirect_to(room_url(room))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the message' do
        message = create(:message, content: 'original content')

        patch room_message_url(room, message), params: { message: { foo: 'bar' } }

        message.reload
        expect(message.content).to eq 'original content'
      end

      it 'redirects to the room page' do
        message = create(:message, content: 'original content')

        patch room_message_url(room, message), params: { message: { content: 'new content' } }

        expect(response).to redirect_to(room_url(room))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested message' do
      message = create(:message, room:)

      expect do
        delete room_message_url(room, message)
      end.to change(room.messages, :count).by(-1)
    end

    it 'redirects to the room page' do
      message = create(:message, room:)

      delete room_message_url(room, message)

      expect(response).to redirect_to(room_url(room))
    end
  end
end

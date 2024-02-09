# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/rooms', type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  before do
    sign_in user
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get room_url(room)

      expect(response).to have_http_status(:success)
    end

    it 'returns the messages belonging to the room' do
      message1 = create(:message, user:, room:)
      message2 = create(:message, user:, room:)

      get room_url(room)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(message1.content)
      expect(response.body).to include(message2.content)
      expect(response.body).to include(user.email)
    end

    it 'displays a form for creating messages' do
      get room_url(room)

      expect(response).to have_http_status(:success)
      expect(response.body).to have_selector("form[action='#{room_messages_path(room)}'][method='post']")
    end
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get rooms_url

      expect(response).to have_http_status(:success)
    end

    it 'returns the rooms' do
      room1 = create(:room)
      room2 = create(:room)

      get rooms_url

      expect(response).to have_http_status(:success)
      expect(response.body).to include(room1.name)
      expect(response.body).to include(room2.name)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_room_url

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Room' do
        expect do
          post rooms_url, params: { room: { name: 'New Room' } }
        end.to change(Room, :count).by(1)
      end

      it 'redirects to the created room' do
        post rooms_url, params: { room: { name: 'New Room' } }

        expect(response).to redirect_to(room_url(Room.last))
      end
    end

    xcontext 'with invalid parameters' do
    end
  end
end

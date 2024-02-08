# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/rooms', type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  before do
    sign_in user
  end

  describe 'GET /post' do
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
end

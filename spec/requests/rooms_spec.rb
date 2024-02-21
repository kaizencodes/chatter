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

    it 'does not allow access the private rooms where the user is not the owner' do
      private_room = create(:room, owner: create(:user))

      get room_url(private_room)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to rooms_url
    end

    it 'allows access to rooms where the user is a member' do
      private_room = create(:room, owner: create(:user))
      message1 = create(:message, user:, room: private_room)
      private_room.members << user

      get room_url(private_room)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(message1.content)
    end
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get rooms_url

      expect(response).to have_http_status(:success)
    end

    it 'returns the public rooms' do
      room1 = create(:room)
      room2 = create(:room)

      get rooms_url

      expect(response).to have_http_status(:success)
      expect(response.body).to include(room1.name)
      expect(response.body).to include(room2.name)
    end

    it 'does not return the private rooms where the user is not the owner' do
      public_room = create(:room)
      other_room = create(:room, owner: create(:user))
      own_room = create(:room, owner: user)

      get rooms_url

      expect(response).to have_http_status(:success)
      expect(response.body).to include(public_room.name)
      expect(response.body).to include(own_room.name)
      expect(response.body).not_to include(other_room.name)
    end

    it 'returns the private rooms where the user is a member' do
      public_room = create(:room)
      other_room = create(:room, owner: create(:user))
      own_room = create(:room, owner: user)
      other_room.members << user

      get rooms_url

      expect(response).to have_http_status(:success)
      expect(response.body).to include(public_room.name)
      expect(response.body).to include(own_room.name)
      expect(response.body).to include(other_room.name)
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

    context 'with private set to true' do
      it 'assigns the current user as the owner' do
        post rooms_url, params: { room: { name: 'New Room', private: '1' } }
        expect(Room.last.owner).to eq(user)
      end
    end

    context 'with private set to false' do
      it 'does not assign the current user as the owner' do
        post rooms_url, params: { room: { name: 'New Room', private: '0' } }
        expect(Room.last.owner).to be_nil
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Room' do
        expect do
          post rooms_url, params: { room: { name: '' } }
        end.to change(Room, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post rooms_url, params: { room: { name: '' } }

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /add_member' do
    let(:room) { create(:room, owner: user) }
    let(:other_user) { create(:user) }

    it 'adds a user to the room' do
      post add_member_room_url(room), params: { room: { user_id: other_user.id } }
      expect(room.members).to include(other_user)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/messages', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get messages_url

      expect(response).to have_http_status(:success)
    end

    it 'returns the messages' do
      message = create(:message, user:)

      get messages_url

      expect(response).to have_http_status(:success)
      expect(response.body).to include(message.content)
      expect(response.body).to include(user.email)
    end

    it 'displays a form for creating messages' do
      get messages_url

      expect(response).to have_http_status(:success)
      expect(response.body).to have_selector("form[action='#{messages_path}'][method='post']")
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      message = create(:message)
      get edit_message_url(message)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(message.content)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Message' do
        expect do
          post messages_url, params: { message: attributes_for(:message) }
        end.to change(Message, :count).by(1)
      end

      it 'redirects to the messages page' do
        post messages_url, params: { message: attributes_for(:message) }
        expect(response).to redirect_to(messages_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Message' do
        expect do
          post messages_url, params: { message: { foo: 'bar' } }
        end.to change(Message, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post messages_url, params: { message: { foo: 'bar' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested message' do
        message = create(:message, content: 'original content')

        patch message_url(message), params: { message: { content: 'new content' } }

        message.reload
        expect(message.content).to eq 'new content'
      end

      it 'redirects to the messages page' do
        message = create(:message, content: 'original content')

        patch message_url(message), params: { message: { content: 'new content' } }

        message.reload
        expect(response).to redirect_to(messages_url)
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        message = create(:message, content: 'original content')

        patch message_url(message), params: { message: { foo: 'bar' } }

        expect(response).to have_http_status(:found)
        message.reload
        expect(message.content).to eq 'original content'
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested message' do
      message = create(:message)

      expect do
        delete message_url(message)
      end.to change(Message, :count).by(-1)
    end

    it 'redirects to the messages list' do
      message = create(:message)

      delete message_url(message)

      expect(response).to redirect_to(messages_url)
    end
  end
end

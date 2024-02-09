# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesHelper, type: :helper do
  describe '#message_belongs_to_current_user?' do
    let(:user) { create(:user) }
    let(:message) { create(:message, user:) }

    context 'when the message belongs to the current user' do
      before do
        allow(helper).to receive(:current_user).and_return(user)
      end

      it 'returns true' do
        expect(helper.message_belongs_to_current_user?(message)).to eq(true)
      end
    end

    context 'when the message does not belong to the current user' do
      before do
        allow(helper).to receive(:current_user).and_return(create(:user))
      end

      it 'returns false' do
        expect(helper.message_belongs_to_current_user?(message)).to eq(false)
      end
    end
  end
end

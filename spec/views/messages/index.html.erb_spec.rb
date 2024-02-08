# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/index', type: :view do
  it 'renders a list of messages' do
    user = create(:user, email: 'user@example.com')
    sign_in user
    message1 = create(:message, content: 'First message', user:)
    message2 = create(:message, content: 'Second message', user:)
    assign(:messages, [message1, message2])

    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'

    assert_select cell_selector, text: /First message/, count: 1
    assert_select cell_selector, text: /Second message/, count: 1
    assert_select cell_selector, text: /user@example.com/, count: 2
  end
end

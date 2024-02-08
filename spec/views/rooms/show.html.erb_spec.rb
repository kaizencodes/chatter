# spec/views/rooms_show_spec.rb
require 'rails_helper'

RSpec.describe 'rooms/show', type: :view do
  let(:room) { create(:room, name: 'Room 1') }

  before(:each) do
    assign(:room, room)
  end

  xit 'renders the room name' do
    render
    expect(rendered).to match(/Room 1/)
  end
end

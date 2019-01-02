# frozen_string_literal: true

require 'spec_helper'

RSpec.describe :register_user do
  let(:app) { test_app }
  let(:username) { 'a_user' }
  def register_user
    app.execute_command(:register_user,
                        email: 'user@example.com',
                        username: username)
  end

  context 'when no user has been registered' do
    it 'persists a new user' do
      register_user
      expect(app[:all_persisted_objects].call).to(
        include(include(username: username))
      )
    end

    it 'enqueues a welcome email for the user' do
      app.handle_query(:generate_id) { |*| 'user-id' }
      enqueue_welcome_email = [:send_email, type: :user_welcome, to: 'user-id']
      expect(register_user).to include(enqueue_welcome_email)
    end
  end

  context 'when a user has been registered already' do
    it 'returns an error' do
      expect(register_user).not_to include(%i[error user_exists])
      expect(register_user).to include(%i[error user_exists])
    end
  end
end

# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'app')

require 'main'

def test_app
  memory = []
  errors = []
  sent_emails = []
  App.register(:all_persisted_objects) do
    -> { memory }
  end
  App.register(:errors) do
    errors
  end
  App.register(:sent_emails) { sent_emails }
  App.handle_effect(:persist, memory.method(:push))
  App.handle_effect(:error, errors.method(:push))
  App.handle_effect(:send_email, sent_emails.method(:push))
  App[:instrumentation].disable!

  App
end

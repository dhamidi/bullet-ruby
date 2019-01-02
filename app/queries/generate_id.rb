# frozen_string_literal: true

require 'securerandom'

app.defquery(:generate_id,
             params: {},
             returns: :id)

app.handle_query(:generate_id) do |_params|
  SecureRandom.uuid
end

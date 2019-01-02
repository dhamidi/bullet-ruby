# frozen_string_literal: true

app.defquery(
  :all_users,
  params: {},
  returns: [:user]
)

app.handle_query(:all_users) do |_params|
  app[:all_persisted_objects].call.select { |obj| obj[:_type] == :user }
end

# frozen_string_literal: true

app.defquery(
  :find_user_by_email,
  params: {
    email: :email
  },
  returns: {
    _id: :id,
    _type: :symbol,
    username: :username,
    is_registered: :bool
  }
)
app.handle_query(:find_user_by_email) do |params|
  not_found = {
    _id: '',
    _type: :user,
    username: 'not_found',
    email: params[:email],
    is_registered: false
  }

  user = app[:all_persisted_objects].call.find do |u|
    u[:email] == params[:email]
  end

  user || not_found
end

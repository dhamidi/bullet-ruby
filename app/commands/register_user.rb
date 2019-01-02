# frozen_string_literal: true

app.defcommand(:register_user) do
  {
    queries: {
      user: [:find_user_by_email, email: %i[ref email]],
      new_user_id: [:generate_id]
    },
    params: {
      email: :email,
      username: :username
    }
  }
end

app.handle_command(:register_user) do |params, context|
  if context[:user][:is_registered]
    [%i[error user_exists]]
  else
    user = context[:user].merge(
      is_registered: true,
      _type: :user,
      _id: context[:new_user_id],
      username: params[:username],
      email: params[:email]
    )
    [
      [:persist, user],
      [:send_email, type: :user_welcome, to: user[:_id]]
    ]
  end
end

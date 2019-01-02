# frozen_string_literal: true

app.deftype(:user) do |v|
  app.apply_schema(
    {
      _id: :id,
      email: :email,
      username: :username
    },
    v
  )
end
app.deftype(:id, &:to_s)
app.deftype(:bool) { |v| !!v }
app.deftype(:symbol, &:to_sym)
app.deftype(:email) do |v|
  text = v.to_s.strip
  raise "#{text.inspect} is not a valid email" unless
    text.match?(/[^@]+@[^@ ]+/)

  text
end

app.deftype(:username) do |v|
  text = v.to_s.strip
  raise "#{text.inspect} is not a valid username" unless
    text.match?(/[A-Za-z_][A-Za-z_0-9]{5,}/)

  text
end

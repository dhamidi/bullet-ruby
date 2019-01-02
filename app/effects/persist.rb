# frozen_string_literal: true

app.handle_effect(:persist) do |params|
  object_id = params.fetch(:_id)
  as_bytes = Marshal.dump(params)
  File.write("persisted-#{object_id}", as_bytes)
  File.open('persisted-index', 'a') { |f| f.puts object_id }
end

# frozen_string_literal: true

app.handle_effect(:error) do |params|
  $stderr.puts "Error: #{params.inspect}"
end

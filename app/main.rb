# frozen_string_literal: true

require_relative '../lib/bullet'

app = Bullet::System.new
context = binding

Dir[File.dirname(__FILE__) + '/**/*.rb'].each do |file|
  next if File.absolute_path(file) == File.absolute_path(__FILE__)

  context.eval File.read(file), file
end

if $PROGRAM_NAME == __FILE__
  puts app.execute_command(:register_user, email: 'user@example.com', username: 'a_user').inspect
  puts app.run_query(:all_users, {}).inspect
else
  App = app
end

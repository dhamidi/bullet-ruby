# frozen_string_literal: true

module Bullet
  class CommandDispatcher
    extend Dry::Initializer
    include Dry::Container::Mixin

    option :commands
    option :query_dispatcher

    def call(raw_command)
      command_name, *command_args = raw_command
      command_class = commands.resolve(command_name)
      context = command_class.queries.map do |(key, *query)|
        [key, query_dispatcher.call(query, *command_args)]
      end.to_h
      command = command_class.new(*command_args)
      handler = resolve(command_name)
      handler.call(command, context)
    end
  end
end

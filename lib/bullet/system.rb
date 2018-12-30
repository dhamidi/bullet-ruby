# frozen_string_literal: true

module Bullet
  class System
    extend Dry::Initializer

    option :queries, default: proc { Dry::Container.new }
    option :commands, default: proc { Dry::Container.new }
    option :effects, default: proc { Dry::Container.new }

    option :effect_executor, default: (proc do
      EffectExecutor.new(effects: effects)
    end)
    option :query_dispatcher, default: (proc do
      QueryDispatcher.new(queries: queries)
    end)
    option :command_dispatcher, default: (proc do
      CommandDispatcher.new(
        query_dispatcher: query_dispatcher,
        commands: commands
      )
    end)

    def execute(*command)
      effects = command_dispatcher.call(command)
      effect_executor.call(Array(effects))
      effects
    end

    def register_directory(directory, into:, namespace:)
      Pathname.new(directory).children.map do |c|
        load c
        constant_name = Bullet.inflector.camelize(c.basename('.rb').to_s)
        value = namespace.const_get(constant_name)
        into.register(value.typename, value)
        value
      end
    end
  end
end

# frozen_string_literal: true

module Bullet
  class DefaultCommandExecutor
    attr_reader :system

    def initialize(system)
      @system = system
    end

    def call(command_name, params)
      command = system[:commands][command_name]
      context = build_context_from_queries(command, params)
      command_params = system.apply_schema(command[:params], params)
      effects = system[:command_handlers][command_name].call(
        command_params,
        context
      )
      system.apply_effects(effects)
    end

    private

    def build_context_from_queries(command, params)
      command[:queries].each_with_object({}) do |(key, definition), result|
        query_name, query_params, *_rest = definition
        query_params = Resolve.resolve(query_params, params)
        result[key] = system.run_query(query_name, query_params)
      end
    end
  end
end

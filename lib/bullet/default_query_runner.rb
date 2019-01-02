# frozen_string_literal: true

module Bullet
  class DefaultQueryRunner
    attr_reader :system

    def initialize(system)
      @system = system
    end

    def call(query_name, params)
      query_schema = system[:queries][query_name][:params]
      query_params = system.apply_schema(query_schema, params)
      result = system[:query_handlers].fetch(query_name).call(query_params)
      system.apply_schema(system[:queries][query_name][:returns], result)
    end
  end
end

# frozen_string_literal: true

module Bullet
  class QueryDispatcher
    extend Dry::Initializer
    include Dry::Container::Mixin

    option :queries

    def call(raw_query, params)
      query_name, *query_args = raw_query
      query_class = queries.resolve(query_name)
      query = query_class.new(*resolve_params(query_args, params))
      handler = resolve(query_name)
      handler.call(query)
    end

    private

    def resolve_params(params, context)
      case params
      when Hash
        resolve_hash(params, context)
      when Array
        resolve_array(params, context)
      else
        params
      end
    end

    def resolve_hash(params, context)
      params.map do |(k, v)|
        [k, resolve_params(v, context)]
      end.to_h
    end

    def resolve_array(params, context)
      if params.length == 2 && params[0] == :ref && params[1].is_a?(Symbol)
        context[params[1]]
      else
        params.map { |e| resolve_params(e, context) }
      end
    end
  end
end

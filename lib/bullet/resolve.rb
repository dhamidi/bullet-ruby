# frozen_string_literal: true

module Bullet
  module Resolve
    module_function

    def resolve(params, context)
      case params
      when Hash
        resolve_hash_param(params, context)
      when Array
        resolve_array_param(params, context)
      else
        params
      end
    end

    def resolve_hash_param(params, context)
      params.each_with_object({}) do |(key, value), result|
        result[key] = resolve(value, context)
      end
    end

    def resolve_array_param(params, context)
      if params.length == 2 && params[0] == :ref && params[1].is_a?(Symbol)
        context[params[1]]
      else
        params.map { |p| resolve(p, context) }
      end
    end
  end
end

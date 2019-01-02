# frozen_string_literal: true

module Bullet
  module Schema
    module_function

    def apply_schema(types, schema, values)
      case schema
      when Hash
        apply_hash_schema(types, schema, values)
      when Array
        apply_array_schema(types, schema, values)
      when Symbol
        apply_scalar_schema(types, schema, values)
      end
    end

    def apply_hash_schema(types, schema, values)
      schema.keys.each_with_object({}) do |name, result|
        type = schema[name]
        result[name] = apply_schema(types, type, values[name])
      end
    end

    def apply_array_schema(types, schema, values)
      element_type = schema.first
      values.map do |v|
        apply_schema(types, element_type, v)
      end
    end

    def apply_scalar_schema(types, schema, values)
      types[schema].call(values)
    end
  end
end

# frozen_string_literal: true

module Bullet
  class Container
    def initialize(parent = self, name: 'anonymous')
      @name = name
      @parent = parent
      @constructors = {}
      @instances = {}
    end

    def register(key, constructor_fn = nil, &constructor_block)
      constructors[key] = constructor_block || constructor_fn || -> { nil }
      instances.delete(key)
    end

    def keys
      constructors.keys
    end

    def wrap(key)
      @instances[key] = yield(fetch(key))
    end

    def fetch(key)
      return parent.fetch(key) unless constructors.key?(key) || parent == self

      fetch_from_this_instance(key)
    end

    def with(entries)
      Container.new(self).tap do |result|
        entries.each do |(key, value)|
          if value.is_a?(Proc)
            result.register(key, value)
          else
            result.register(key) { value }
          end
        end
      end
    end

    alias [] fetch

    private

    attr_reader :constructors, :parent, :instances

    def fetch_from_this_instance(key)
      instances.fetch(key) do
        instances[key] = constructors.fetch(key).call
        instances[key]
      end
    rescue KeyError => err
      raise KeyError, "#{@name}: #{err.message}"
    end
  end
end

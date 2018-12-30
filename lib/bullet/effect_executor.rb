# frozen_string_literal: true

module Bullet
  class EffectExecutor
    extend Dry::Initializer
    include Dry::Container::Mixin

    def call(effects_to_execute)
      effects_to_execute.each do |effect|
        handler = resolve(effect.typename)
        handler.call(effect)
      end
    end
  end
end

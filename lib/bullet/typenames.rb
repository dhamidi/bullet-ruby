# frozen_string_literal: true

module Bullet
  module_function

  def inflector
    @inflector ||= Dry::Inflector.new
  end

  module Typenames
    def typename
      base = if is_a?(Class)
               self
             else
               self.class
             end
      Bullet.inflector.underscore(base.name).split('/').last.to_sym
    end

    def self.included(klass)
      klass.extend(self)
    end
  end
end

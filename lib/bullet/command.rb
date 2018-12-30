# frozen_string_literal: true

module Bullet
  class Command
    include Bullet::Typenames
    extend Dry::Initializer

    def self.query(name, *definition)
      queries << [name, *definition]
      self
    end

    def self.queries
      @queries ||= []
    end
  end
end

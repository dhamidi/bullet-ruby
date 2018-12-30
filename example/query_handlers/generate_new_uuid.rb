# frozen_string_literal: true

require 'securerandom'

module Example
  class GenerateNewUUID < Bullet::QueryHandler
    def call(_query)
      SecureRandom.uuid
    end
  end
end

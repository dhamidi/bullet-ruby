# frozen_string_literal: true

module Example
  class Constant < Bullet::QueryHandler
    param :result, default: proc { nil }

    def call(_query)
      result
    end
  end
end

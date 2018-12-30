# frozen_string_literal: true

module Example
  module Types
    include Dry::Types.module
  end
end

require_relative './types/date_range'

module Example
  module Types
    ID = Strict::String.constrained(format: /\A[a-z0-9][-a-z0-9_]*\Z/)
    Quantity = Strict::Integer.constrained(gt: 0)
  end
end

require_relative './types/booking'

# frozen_string_literal: true

module Example
  class Booking < Dry::Struct
    attribute :id, Types::ID
    attribute :storage_space_id, Types::ID
    attribute :quantity, Types::Quantity
    attribute :available_capacity, Types::Quantity
    attribute :period, Types::DateRange
  end

  module Types
    Booking = Constructor(Booking)
  end
end

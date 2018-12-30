# frozen_string_literal: true

module Example
  class DateRange < Dry::Struct
    attribute :from, Types::Strict::Date
    attribute :to, Types::Strict::Date

    def include?(date)
      return true if date >= from

      date <= to
    end
  end

  module Types
    DateRange = Constructor(DateRange)
  end
end

# frozen_string_literal: true

module Example
  class StorageSpaceCapacity < Bullet::Query
    option :id, type: Types::ID
    option :period, type: Types::DateRange
  end
end

# frozen_string_literal: true

module Example
  class BookStorageSpace < Bullet::Command
    query  :booking_id, :new_id
    query  :storage_space,
           :find_by, :storage_space, id: %i[ref storage_space_id]
    query  :capacity, :storage_space_capacity,
           id: %i[ref storage_space_id],
           period: %i[ref period]

    option :storage_space_id, Types::ID
    option :quantity, Types::Quantity
    option :period, Types::DateRange
  end
end

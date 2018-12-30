# frozen_string_literal: true

module Example
  class BookStorageSpaceHandler < Bullet::CommandHandler
    def call(command, context)
      puts command.inspect, context.inspect
      if context[:capacity] < command.quantity
        raise ArgumentError,
              "Not enough capacity: #{context[:capacity]} available," \
              " #{command.quantity} requested"
      end

      booking = Types::Booking[
        id: context[:booking_id],
        storage_space_id: command.storage_space_id,
        quantity: command.quantity,
        available_capacity: context[:capacity],
        period: command.period,
      ]

      [
        PersistEntity.new(:booking, booking)
      ]
    end
  end
end

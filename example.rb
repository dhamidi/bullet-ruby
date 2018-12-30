# frozen_string_literal: true

require 'dry-struct'
require 'dry-initializer'
require 'dry-container'

require 'dry-initializer'

class Command
  extend Dry::Initializer

  def self.query(name, *definition)
    queries << [name, *definition]
    self
  end

  def self.queries
    @queries ||= []
  end
end

class Query
  extend Dry::Initializer
end

module Types
  include Dry::Types.module
end

class DateRange < Dry::Struct
  attribute :from, Types::Strict::Date
  attribute :to, Types::Strict::Date

  def include?(date)
    return true if date >= from

    date <= to
  end
end

module Types
  ID = Strict::String.constrained(format: /\A[a-z0-9][-a-z0-9_]*\Z/)
  Quantity = Strict::Integer.constrained(gt: 0)
  DateRange = Constructor(DateRange)
end

class BookStorageSpace < Command
  query  :storage_space, :find_by, :storage_space, id: %i[ref storage_space_id]
  query  :capacity, :storage_space_capacity,
         id: %i[ref storage_space_id],
         period: %i[ref period]

  option :storage_space_id, Types::ID
  option :quantity, Types::Quantity
  option :period, Types::DateRange
end

queries = Dry::Container.new

module Queries
  class FindBy < Query
    param :type, Types::Strict::Symbol
    param :params, Types::Strict::Hash
  end
end

module Queries
  class StorageSpaceCapacity < Query
    option :id, Types::ID
    option :period, Types::DateRange
  end
end

queries.register(:find_by, Queries::FindBy)
queries.register(:storage_space_capacity, Queries::StorageSpaceCapacity)

ResolveParams = lambda do |params, context|
  case params
  when Hash
    params.map do |(k, v)|
      [k, ResolveParams.(v, context)]
    end.to_h
  when Array
    if params.length == 2 && params[0] == :ref && params[1].is_a?(Symbol)
      context[params[1]]
    else
      params.map { |e| ResolveParams.(e, context) }
    end
  else
    params
  end
end

class CommandDispatcher
  extend Dry::Initializer
  include Dry::Container::Mixin

  option :commands
  option :query_dispatcher

  def call(raw_command)
    command_name, *command_args = raw_command
    command_class = commands.resolve(command_name)
    context = command_class.queries.map do |(key, *query)|
      [key, query_dispatcher.call(query, *command_args)]
    end.to_h
    command = command_class.new(*command_args)
    handler = resolve(command_name)
    handler.call(command, context)
  end
end

class QueryDispatcher
  extend Dry::Initializer
  include Dry::Container::Mixin

  option :queries

  def call(raw_query, params)
    query_name, *query_args = raw_query
    query_class = queries.resolve(query_name)
    query = query_class.new(*ResolveParams.(query_args, params))
    handler = resolve(query_name)
    handler.call(query)
  end
end

module Models
  class StorageSpace < Dry::Struct
    attribute :id, Types::ID
    attribute :warehouse_id, Types::ID
    attribute :state, Types::Strict::Symbol.enum(:active)
  end
end

query_dispatcher = QueryDispatcher.new(queries: queries)
query_dispatcher.register(:storage_space_capacity) do |query|
  puts query.inspect
  5
end

query_dispatcher.register(:find_by) do |query|
  Models::StorageSpace.new(
    id: query.params[:id],
    warehouse_id: 'warehouse-1',
    state: :active
  )
end
commands = Dry::Container.new
commands.register(:book_storage_space, BookStorageSpace)
command_dispatcher = CommandDispatcher.new(commands: commands, query_dispatcher: query_dispatcher)
command_dispatcher.register(:book_storage_space) do |command, context|
  if context[:capacity] < command.quantity
    raise ArgumentError,
          "Not enough capacity: #{context[:capacity]} available, #{command.quantity} requested"
  end

  :ok
end

puts command_dispatcher.call([:book_storage_space,
                         storage_space_id: 'storage-space-1',
                         quantity: 2,
                         period: DateRange.new(
                           from: Date.today,
                           to: Date.today + 7
                         )])

require 'minitest'
require 'dry/container/stub'
System = {
  query_dispatcher: query_dispatcher,
  command_dispatcher: command_dispatcher
}
module Tests
  class BookStorageSpaceTest < Minitest::Test
    def setup
      System[:query_dispatcher].enable_stubs!
    end

    def for_a_week
      DateRange.new(from: Date.today, to: Date.today + 7)
    end

    def test_it_raises_an_error_when_trying_to_book_more_than_the_available_capacity
      System[:query_dispatcher].stub(:storage_space_capacity, proc { 1 })
      assert_raises(ArgumentError) do
        System[:command_dispatcher].call(
          [:book_storage_space,
           storage_space_id: 'storage-space-1',
           quantity: 2,
           period: for_a_week]
        )
      end
    end
  end
end

Minitest.run if $PROGRAM_NAME == File.basename(__FILE__)

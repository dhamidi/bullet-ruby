# frozen_string_literal: true

require_relative './app'

require 'elasticsearch'
dependencies = Dry::Container.new
dependencies.register(:logger, ::Logger.new(STDOUT))
dependencies.register(:elasticsearch) do
  client = Elasticsearch::Client.new
  client.transport.logger = dependencies.resolve(:logger)
  client
end
app = Example.system do |system|
  Example.load!(system)
  system.query_dispatcher.register(
    :find_by, Example::FindByElasticsearch.new(
                elasticsearch: dependencies.resolve(:elasticsearch)
              )
  )
  system.query_dispatcher.register(
    :new_id, Example::GenerateNewUUID.new
  )
  system.query_dispatcher.register(
    :storage_space_capacity, Example::Constant.new(5)
  )
  system.command_dispatcher.register(
    :book_storage_space,
    Example::BookStorageSpaceHandler.new
  )
  system.effect_executor.register(
    :persist_entity,
    Example::UpdateElasticsearchDocument.new(
      elasticsearch: dependencies.resolve(:elasticsearch)
    )
  )
end

require 'pry'; binding.send(:pry)

1

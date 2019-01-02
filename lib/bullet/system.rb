# frozen_string_literal: true

module Bullet
  class System < SimpleDelegator
    def initialize
      @root = Container.new
      %i[queries query_handlers
         commands command_handlers
         types effects].each do |name|
        @root.register(name) { Container.new(name: name) }
      end
      @root.register(:executor) { DefaultCommandExecutor.new(self) }
      @root.register(:query_runner) { DefaultQueryRunner.new(self) }
      @root.register(:applier) do
        lambda do |effect_name, args|
          self[:effects][effect_name].call(args)
        end
      end
      __setobj__(@root)
    end

    def with(overrides)
      result = self.class.new
      result.__setobj__(@root.with(overrides))
      result
    end

    def run_query(query_name, params)
      self[:query_runner].call(query_name, params)
    end

    def execute_command(command_name, params)
      self[:executor].call(command_name, params)
    end

    def apply_schema(schema, values)
      Schema.apply_schema(self[:types], schema, values)
    end

    def apply_effects(effects)
      effects.each do |effect|
        effect_name, *args = effect
        self[:applier].call(effect_name, *args)
      end
    end

    def deftype(name, &coerce)
      self[:types].register(name) { coerce }
    end

    def defcommand(name, definition = nil)
      definition ||= yield
      self[:commands].register(name) do
        definition.merge(name: name)
      end
    end

    def defquery(query_name, params)
      self[:queries].register(query_name) do
        if params.key?(:params)
          { name: query_name }.merge(params)
        else
          { name: query_name, params: params }
        end
      end
    end

    def handle_query(query_name, handler = nil, &handler_block)
      handler ||= handler_block
      self[:query_handlers].register(query_name, -> { handler })
    end

    def handle_command(command_name, handler = nil, &handler_block)
      handler ||= handler_block
      self[:command_handlers].register(command_name, -> { handler })
    end

    def handle_effect(effect_name, handler = nil, &handler_block)
      handler ||= handler_block
      self[:effects].register(effect_name, -> { handler })
    end
  end
end

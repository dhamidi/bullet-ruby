# frozen_string_literal: true

require 'bullet'
require_relative './types'

module Example
  module_function

  def system
    system = Bullet::System.new
    yield(system)
    system
  end

  def load!(system)
    base = Pathname.new(__FILE__).dirname
    register_directories(base, system)
    load_directories(base)
  end

  def register_directories(base, system)
    system.register_directory(base.join('queries'),
                              into: system.queries, namespace: Example)
    system.register_directory(base.join('commands'),
                              into: system.commands, namespace: Example)
    system.register_directory(base.join('effects'),
                              into: system.effects, namespace: Example)
  end

  def load_directories(base)
    load_directory(base.join('command_handlers'))
    load_directory(base.join('query_handlers'))
    load_directory(base.join('effect_handlers'))
  end

  def load_directory(dir)
    Pathname.new(dir).children.each do |child|
      next unless child.extname == '.rb'

      load child
    end
  end
end

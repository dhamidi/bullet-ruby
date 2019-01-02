# frozen_string_literal: true

class TextInstrumenter
  def initialize
    @enabled = true
    @level = 0
  end

  def enable!
    @enabled = true
  end

  def disable!
    @enabled = false
  end

  def call(tag, *args, &block)
    return yield unless @enabled

    puts "#{' ' * @level}#{tag}"
    start = Time.now.to_f
    @level += 1
    result = block.call
    @level -= 1
    delta_millis = ((Time.now.to_f - start) * 1000).to_i
    prefix = (' ' * @level) + tag.to_s
    puts "#{prefix} #{delta_millis}ms #{args.map(&:inspect).join(' ')}"
    result
  end
end

app.register(:instrumentation) do
  TextInstrumenter.new
end

app.wrap(:query_runner) do |runner|
  lambda do |query_name, params|
    app[:instrumentation].call(query_name, params) do
      runner.call(query_name, params)
    end
  end
end

app.wrap(:executor) do |executor|
  lambda do |command_name, params|
    app[:instrumentation].call(command_name) do
      executor.call(command_name, params)
    end
  end
end

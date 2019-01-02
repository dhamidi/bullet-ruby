# frozen_string_literal: true

def all_persisted_objects
  File.readlines('persisted-index').map do |object_id_with_newline|
    object_id = object_id_with_newline.chomp
    Marshal.load(File.read("persisted-#{object_id}"))
  end
rescue Errno::ENOENT
  []
end

app.register(:all_persisted_objects, -> { method(:all_persisted_objects) })

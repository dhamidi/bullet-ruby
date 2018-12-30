# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bullet/version'

Gem::Specification.new do |spec|
  spec.name          = 'bullet'
  spec.version       = Bullet::VERSION
  spec.authors       = ['Dario Hamidi']
  spec.email         = ['dario@gowriteco.de']

  spec.summary       = 'Not quite a silver bullet for application development'
  spec.homepage      = 'https://github.com/bullet-framework/bullet'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either
  # set the 'allowed_push_host' to allow pushing to a single host or
  # delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-initializer', '~> 2.5.0'
  spec.add_dependency 'dry-types', '~> 0.13.3'
  spec.add_dependency 'dry-struct', '~> 0.6.0'
  spec.add_dependency 'dry-inflector', '~> 0.1.2'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.61.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.5.0'
end

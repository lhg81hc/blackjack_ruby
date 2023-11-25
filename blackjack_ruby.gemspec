# frozen_string_literal: true

require_relative "lib/blackjack_ruby/version"

Gem::Specification.new do |spec|
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', "~> 5.0"
  spec.add_development_dependency 'rubocop', "~> 1.21"

  spec.name = "blackjack_ruby"
  spec.version = BlackjackRuby::VERSION
  spec.authors = ["Thad Le"]
  spec.email = ["llengocthangg@gmail.com"]

  spec.summary = "A Ruby simulation for Blackjack"
  spec.description = "Blackjack simulation in Ruby"
  spec.homepage = "https://github.com/lhg81hc/blackjack_ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

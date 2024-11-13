# frozen_string_literal: true

require_relative "lib/jekyll2zola/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll2zola"
  spec.version = Jekyll2zola::VERSION
  spec.authors = ["MATSUMOTO, Katsuyoshi"]
  spec.email = ["github@katsyoshi.org"]

  spec.summary = "jekyll to zola"
  spec.description = spec.summary
  spec.homepage = "https://katsyoshi.org"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

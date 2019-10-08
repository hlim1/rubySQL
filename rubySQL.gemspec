lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubySQL/version"

Gem::Specification.new do |spec|
  spec.name          = "rubySQL"
  spec.version       = RubySQL::VERSION
  spec.authors       = ["Terrence Lim"]
  spec.email         = ["hlim1@email.arizona.edu"]

  spec.summary       = %q{This gem is for database management purpose.}
  spec.description   = %q{Developers who uses this can manage their database only with Ruby code.}
  spec.homepage      = "https://github.com/hlim1/rubySQL"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hlim1/rubySQL"
  spec.metadata["changelog_uri"] = "https://github.com/hlim1/rubySQL/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  # Specifying that 'rspec' is a development dependency.
  spec.add_development_dependency "rspec", "~> 3.2"
end

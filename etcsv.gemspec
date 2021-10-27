require_relative 'lib/etcsv/version'

Gem::Specification.new do |spec|
  spec.name          = "etcsv"
  spec.version       = Etcsv::VERSION
  spec.authors       = ["iamfm"]
  spec.email         = ["julika27@gmail.com"]

  spec.summary       = "Provides API to convert Etsy shop catalog into CSV file ready for Facebook Catalog upload"
  spec.homepage      = "https://github.com/iamfmjk/etcsv"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/iamfmjk/etcsv"
  spec.metadata["changelog_uri"] = "https://github.com/iamfmjk/etcsv/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

#  spec.add_runtime_dependency "etsy"
  spec.add_runtime_dependency "json"

end

require_relative 'lib/docx_replacor/version'

Gem::Specification.new do |spec|
  spec.name          = "docx_replacor"
  spec.version       = DocxReplacor::VERSION
  spec.authors       = ["Justiceshrs Portal"]
  spec.email         = ["justiceshrsportal@gmail.com"]

  spec.summary       = %q{Ruby library for text replacement in docx file}
  spec.homepage      = "https://github.com/jusportal/docx_replacor"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jusportal/docx_replacor"
  spec.metadata["changelog_uri"] = "https://github.com/jusportal/docx_replacor"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
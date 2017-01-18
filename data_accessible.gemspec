# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_accessible/version'

Gem::Specification.new do |spec|
  spec.name          = "data_accessible"
  spec.version       = DataAccessible::VERSION
  spec.authors       = ["Jeff Nyman"]
  spec.email         = ["jeffnyman@gmail.com"]

  spec.summary       = %q{Provides accessibility mechanism for data.}
  spec.description   = %q{Provides accessibility mechanism for data.}
  spec.homepage      = "https://github.com/jeffnyman/data_accessible"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "pry"

  spec.post_install_message = %{
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  DataAccessible #{DataAccessible::VERSION} has been installed.
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  }
end

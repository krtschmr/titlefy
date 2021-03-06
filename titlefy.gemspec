# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'titlefy/version'

Gem::Specification.new do |spec|
  spec.name          = "titlefy"
  spec.version       = Titlefy::VERSION
  spec.authors       = ["Tim Kretschmer"]
  spec.email         = ["tim@krtschmr.de"]

  spec.summary       = %q{Extract your titletags from I18n backend.}
  spec.description   = %q{Set your title-tag content based on I18n locales. Just add title_tag key to your YML File and the magic begins. Lookup for Namespace|Controller|ActionName or Controller|Actionname or RouteName or Default. Also supports passing variables into the title tag}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end

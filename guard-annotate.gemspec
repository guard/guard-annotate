# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/annotate/version"

Gem::Specification.new do |s|
  s.name        = "guard-annotate"
  s.version     = Guard::AnnotateVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Craig P Jolicoeur"]
  s.email       = ["cpjolicoeur@gmail.com"]
  s.homepage    = "http://craigjolicoeur.com"
  s.summary     = %q{Guard gem for annotate}
  s.description = %q{Guard::Annotate automatically runs the annotate gem when needed}
  s.license     = "MIT"

  s.post_install_message = %Q(** guard-annotate is looking for maintainers. While I am still trying
  to accept and stay on top of new Pull Requests, I no longer personally actively use this guard
  plugin.  If you are interested in becoming a maintainer please contact me via GitHub Issues at
  https://github.com/guard/guard-annotate. **)

  s.rubyforge_project = "guard-annotate"

  s.add_dependency 'guard-compat', '~> 1.2', '>= 1.2.1'
  s.add_dependency 'annotate', '~> 2.4', '>= 2.4.0'

  s.add_development_dependency 'bundler', '~> 1.6'

  s.files = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8", "--main=README.rdoc", "--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'"]
end

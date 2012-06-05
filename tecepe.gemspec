# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tecepe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ismael Celis"]
  gem.email         = ["ismaelct@gmail.com"]
  gem.description   = %q{Tiny evented TCP server for JSON services}
  gem.summary       = %q{Tiny evented TCP server for JSON services}
  gem.homepage      = ""
  
  gem.add_dependency 'eventmachine'
  gem.add_dependency 'json'
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "tecepe"
  gem.require_paths = ["lib"]
  gem.version       = Tecepe::VERSION
end

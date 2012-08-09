# -*- encoding: utf-8 -*-
require File.expand_path('../lib/selkie/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["david-huber"]
  gem.email         = ["david.huber@gmail.com"]
  gem.description   = "A DSL for nerdy games" 
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "selkie"
  gem.require_paths = ["lib"]
  gem.version       = Selkie::VERSION
end

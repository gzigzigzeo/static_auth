require "lib/static_auth/version"

Gem::Specification.new do |s|
  s.name              = "static_auth"
  s.version           = StaticAuth::VERSION
  s.author            = "Victor Sokolov"
  s.email             = "gzigzigzeo@gmail.com"
  s.homepage          = "http://github.com/gzigzigzeo/static_auth"
  s.description       = "Static authentication && authorization in rails."
  s.summary           = "Static authentication && authorization in rails."

  s.rubyforge_project = "static_auth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'activerecord', '~> 3.0.0'
  s.add_dependency 'activesupport', '~> 3.0.0'  
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec'
end
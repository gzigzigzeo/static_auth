require 'rake'
require 'rake/testtask'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

begin
  include_files = ["README*", "LICENSE", "Rakefile", "init.rb", "{lib,spec}/**/*"].map do |glob|
    Dir[glob]
  end.flatten
  
  require "jeweler"
  Jeweler::Tasks.new do |s|
    s.name              = "static_auth"
    s.version           = "0.0.4"
    s.author            = "Victor Sokolov"
    s.email             = "gzigzigzeo@gmail.com"
    s.homepage          = "http://github.com/gzigzigzeo/static-auth"
    s.description       = "Static authentication && authorization in rails"
    s.summary           = "Static authentication && authorization in rails. Supports roles and static passwords."
    s.platform          = Gem::Platform::RUBY
    s.files             = include_files
    s.require_path      = "lib"
    s.has_rdoc          = false
    
    s.add_dependency 'activemodel', '> 3'
    s.add_dependency 'activesupport', '> 3'
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
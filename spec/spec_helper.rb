$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

begin
  require "bundler"
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

Bundler.require

$: << File.join(File.dirname(__FILE__), '..', 'lib')

class AdminSession < StaticAuth::Session
  roles :admin, :manager
  password_for :admin, "123456"
  password_for :manager, proc { encrypt("123456") }
  set_encryption_method :md5
end
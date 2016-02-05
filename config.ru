Bundler.require
require 'rack/contrib/try_static'
require File.join(File.dirname(__FILE__), 'app.rb')

run CfReceiver::App

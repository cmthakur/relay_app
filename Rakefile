Bundler.require
require "./app"

task :routes do
  RelayApp::App.routes.each do |route|
    puts route.to_s.colorize(:green)
  end
end
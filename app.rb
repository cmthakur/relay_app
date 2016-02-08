ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

Dir["#{File.dirname(__FILE__)}/config/initializers/*.rb"].each {|file| require(file)}
Dir["#{File.dirname(__FILE__)}/config/**/*.rb"].each {|file| require(file)}
Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each {|file| require(file)}
Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each {|file| require(file)}
Dir["#{File.dirname(__FILE__)}/api/**/*.rb"].each {|file| require(file)}

I18n.enforce_available_locales = false

module RelayApp
  class App < Grape::API
    mount API::V3::ProductionRunsController
    mount API::V4::ProductionRunsController
  end
end
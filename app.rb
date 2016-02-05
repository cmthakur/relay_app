ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)


I18n.enforce_available_locales = false

module CfReceiver
  class App < Grape::API
    mount API::V1::Base
  end
end
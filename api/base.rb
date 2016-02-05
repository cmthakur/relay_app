Dir["#{File.dirname(__FILE__)}/*.rb"].each {|file| require(file)}
require 'grape-swagger'
require 'digest/sha1'

module API
  module V1
    class Base < Grape::API
      prefix 'api'
      format :json
      version 'v1'


      helpers do
      end

      # mount API::V1::RunsController

      add_swagger_documentation api_version: 'v1',
        mount_path: 'docs',
        hide_format: true,
        hide_documentation_path: true
    end
  end
end

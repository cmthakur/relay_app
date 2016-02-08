require_relative '../../lib/run_utility'
Dir["#{File.dirname(__FILE__)}/*.rb"].each {|file| require(file)}
require 'grape-swagger'
require 'grape-swagger'
require 'digest/sha1'

module API
  module V3
    class ProductionRunsController < Grape::API
      include RunUtility

      resource :runs do

        desc 'this route description'
        get '/' do
        end

        desc 'this route description'
        post '/' do
          parameter = params.merge({version: 'v3'})
          response = RunUtility.verify_request(parameter)
          # if response.blank?
          response = ProductionRun.new(parameter).save
          # end

          response
        end
      end


      prefix 'api'
      format :json
      version 'v3'
      add_swagger_documentation api_version: 'v3',
        mount_path: 'docs',
        hide_format: true,
        hide_documentation_path: true

    end
  end
end

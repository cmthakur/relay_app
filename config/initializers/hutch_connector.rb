module Hutch
  module Connector
    extend self

    def establish_connection
      hutch_config = config
      Hutch::Config.initialize.merge!({
        mq_username: hutch_config['mq_username'],
        mq_password: hutch_config['mq_password'],
        mq_vhost: hutch_config['mq_vhost'],
        mq_host: hutch_config['mq_host'],
        mq_api_host: hutch_config['mq_host'],
        channel_prefetch: 1
        })
    end

    def config
      YAML.load_file(File.expand_path('../../hutch.yml', __FILE__))[(ENV['RACK_ENV']||'development')]
    end
  end
end

Hutch::Connector.establish_connection
client_logger = Logger.new('log/hutch.log')
Hutch::Config.set(:client_logger, client_logger)
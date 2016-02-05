APP_CONFIG = OpenStruct.new(YAML.load_file('config/app_config.yml')[ENV['RACK_ENV'] || 'development'])

def redis
  @redis ||= Redis.new
end
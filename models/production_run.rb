class ProductionRun
  def initialize(args={})
    @params = args
    @version = args[:version] || 'v4'
    @line_id = args[:line_id] || args[:template_id]
  end

  def save
    created_at = Time.now.utc
    access_hash = "#{@line_id}-#{created_at.to_i}"
    @params = @params.merge(created_at: created_at, access_hash: access_hash, version: @version)
    redis.lpush @line_id, @params.to_json
    ::Relay::Producer.publish('client.create_run', @params)

    if @version == 'v4'
      {
        id: access_hash,
        line_id: @line_id,
        status: "Processing",
        created_at: created_at
      }
    else
      {
        task_id: access_hash,
        template_id: @line_id,
        status: "Processing",
        started_at: created_at
      }
    end
  end

  def self.create(params)
    run = ProductionRun.new(params)
    run.save
  end
end
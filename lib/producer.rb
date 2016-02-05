module Relay
  module Producer
    def self.publish(queue, params, mq_exchange='hutch')
      Hutch.connect unless Hutch.connected?
      Hutch.publish(queue, params)
    end
  end
end
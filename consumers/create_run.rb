module RelayApp
  module Consumers
    module ProductionRun
      class Creator
        include Hutch::Consumer
        consume 'client.create_run'
        queue_name 'client_create_run'

        def process(message)
          message = message.body

          if message['version'] == 'v4'
            create_v4_run(message)
          elsif message['version'] == 'v3'
            create_v3_run(message)
          end
        end
      end
    end
  end
end


def create_v4_run(params)
  ActiveRecord::Base.transaction do
    deadline = valid_turnaround_time(params)
    line, klass = run_klass(params)

    tx = klass.create(
      transaction_type_id: line.id,
      callback_url: params['callback_url'],
      deadline: deadline,
      status: Transaction::BOARDING,
      access_hash: params['access_hash'],
      created_at: params['created_at']
    )

    units, status = parse_input(params[:units])
    create_units(units, tx, line)
    start_transaction(tx, line)
  end
end

def create_v3_run(params)
  ActiveRecord::Base.transaction do
    line, klass = run_klass(params)

    tx = klass.create(
      transaction_type_id: line.id,
      callback_url: params['callback_url'],
      deadline:   params['deadline'],
      status: Transaction::BOARDING,
      priority:  params['priority'] || 0,
      access_hash: params['access_hash'],
      created_at: params['created_at']
    )

    units = parse_input(params['resources'])
    create_units(units, tx, line)
    start_transaction(tx, line)
  end
end

def start_transaction(tx, line)
  begin
    if line.data.high_priority
      BeginTransactionWithPriority.perform_async(tx.id)
    else
      BeginTransaction.perform_async(tx.id)
    end
  rescue Exception => e
    cf_notify_error_tracker(e, params)
    Rails.logger.error({
                         class: 'API::RedisConnectionError',
                         id: tx.access_hash,
                         msg: 'redis connection error, unable to enqueue in start transaction',
                         status: 'error',
                         deadline: tx.deadline,
                         error: e,
                         timestamp: Time.now.utc
    })
  end

end


def create_units(units, tx, line)
  units.each_slice(500).to_a.each do |slice|
    data_sources_val = slice.map do |data|
      DataSource.new(transaction_id: tx.id, data: data)
    end
    DataSource.import(data_sources_val) unless data_sources_val.empty?
  end

  if output = line.data.output
    tx.create_output_format(data: { output: output })
  end
end

def run_klass(params)
  line = TransactionType.where(status: TransactionType::VALID, access_hash: params['line_id']).first

  klass = if params["sandbox"].eql?('true')
    APIGenericSandboxTransaction
  else
    if line.transaction_class
      line.transaction_class.constantize_with_care(Transaction::TRANSACTION_LIST)
    else
      params['version'] == 'v4' ? APISimpleRun : APISimpleTransaction
    end
  end

  [line, klass]
end


def parse_input(units)
  status = [String, Array].include?(units.class)
  if units.is_a?(String)
    begin
      units = JSON.parse(units)
      status = units.is_a?(Array)
    rescue
      status = false
    end
  end
  [ units, status]
end

def valid_turnaround_time(params)
  deadline = params['turnaround_time']
  Time.now.utc + deadline.to_i.minutes if deadline
end

class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: "elasticsearch", retry: false

  LOGGER = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  CLIENT = Elasticsearch::Client.new host: "localhost:9200", logger: LOGGER

  def perform_async(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      record = Sake.find(record_id)
      Client.index index: "sakes", type: "sake", id: record.id, body: record.__elasticsearch__.as_indexed_json
    when /delete/
      Client.delete index: "sakes", type: "sake", id: record_id
    else raise ArgumentError, "Unknown operation #{operation}"
    end
  end
end

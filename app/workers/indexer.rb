# Indexer class for <http://sidekiq.org>
#
# Run me with:
#
#     $ bundle exec sidekiq --queue elasticsearch --verbose
#
class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: "elasticsearch", retry: false

  LOGGER = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new(
    url: ENV["ELASTICSEARCH_HOSTS"] || "http://localhost:9200",
    logger: LOGGER,
  )

  def perform(operation, record_id)
    logger.debug([operation, "ID: #{record_id}"])

    case operation.to_s
    when /index/
      record = Sake.find(record_id)
      Client.index({ index: "sakes", id: record.id, body: record.__elasticsearch__.as_indexed_json })
    when /delete/
      Client.delete({ index: "sakes", id: record_id })
    else
      raise(ArgumentError, "Unknown operation #{operation}")
    end
  end
end

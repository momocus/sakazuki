config = {
  url: ENV["ELASTICSEARCH_HOSTS"] || "http://localhost:9200",
}
Elasticsearch::Model.client = Elasticsearch::Client.new(config)

# Print Curl-formatted traces in development into a file
if Rails.env.development?
  tracer = ActiveSupport::Logger.new("log/elasticsearch.log")
  tracer.level = Logger::DEBUG
  Elasticsearch::Model.client.transport.tracer = tracer
end

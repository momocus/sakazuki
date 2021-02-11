config = {
  host: ENV["ELASTICSEARCH_HOST"] || "localhost",
  port: ENV["ELASTICSEARCH_PORT"] || "9200",
}
Elasticsearch::Model.client = Elasticsearch::Client.new(config)

config = {
  url: ENV["ELASTICSEARCH_HOSTS"] || "http://localhost:9200",
}
Elasticsearch::Model.client = Elasticsearch::Client.new(config)

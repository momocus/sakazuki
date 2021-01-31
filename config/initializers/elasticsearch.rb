config = {
  host: ENV["ELASTICSEARCH_HOST"] || "localhost",
  port: ENV["ELASTICSEARCH_PORT"] || "9200",
  user: ENV["ELASTICSEARCH_USER"] || "",
  password: ENV["ELASTICSEARCH_PASSWORD"] || "",
}
Elasticsearch::Model.client = Elasticsearch::Client.new(config)
# yaml = Rails.root.join("config/elasticsearch.yml")
# config = YAML.safe_load(ERB.new(yaml.read).result) || {}
# Elasticsearch::Model.client = Elasticsearch::Client.new(config)

# config = YAML.safe_load(ERB.new(yaml.read).result) || {}

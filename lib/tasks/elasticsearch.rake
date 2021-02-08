require "elasticsearch/rails/tasks/import"
namespace :elasticsearch do
  desc "Elasticsearch のindex作成"
  task create_index: :environment do
    Sake.__elasticsearch__.create_index! force: true
  end
end

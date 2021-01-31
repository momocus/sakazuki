namespace :elasticsearch do
  desc "Elasticsearch のindex作成"
  task create_index: :environment do
    Sake.__elasticsearch__.create_index! force: true
  end

  desc "Sake を Elasticsearch に登録"
  task import_sake: :environment do
    Sake.__elasticsearch__.import
  end
end

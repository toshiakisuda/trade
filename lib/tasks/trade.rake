namespace :trade do
  desc "デイトレード用タスク"

  task :get => :environment do
    stocks = Stock.all
    p stocks
  end
end

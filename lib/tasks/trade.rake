require 'yahoo-finance.rb'

namespace :trade do
  desc "デイトレード用タスク"

  task :get => :environment do
    aaa = YahooFinanceStock.new
    aaa.all_get
  end

  task :oder => :environment do
    aaa = YahooFinanceStock.new
    aaa.oder
  end
end

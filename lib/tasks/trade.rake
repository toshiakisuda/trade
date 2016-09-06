require 'yahoo-finance.rb'

namespace :trade do
  desc "デイトレード用タスク"

  task :get => :environment do
    aaa = YahooFinanceStock.new
    aaa.all_get
  end

  task :order => :environment do
    aaa = YahooFinanceStock.new
    aaa.order "3697", "1391"
  end
end

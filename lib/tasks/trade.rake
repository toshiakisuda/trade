require 'yahoo-finance.rb'

namespace :trade do
  desc "デイトレード用タスク"

  task :get => :environment do
    aaa = YahooFinanceStock.new
    aaa.all_get
  end
end

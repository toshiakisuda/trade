require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
end

session = Capybara::Session.new(:poltergeist)
session.visit "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=3691.T"
puts session.status_code

#yahooの株価
p price = session.find('#stockinf > div.stocksDtl.clearFix > div.forAddPortfolio > table > tbody > tr > td:nth-child(3)').text
p price.delete(",").to_i

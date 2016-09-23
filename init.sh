#! /bin/bash

cd ../
DATE=$(date +'%Y%m%d')
mv trade trade.$DATE
git clone https://github.com/toshiakisuda/trade.git
cd trade
bundle install --path vendor/bundler
rake db:migrate
rake db:seed

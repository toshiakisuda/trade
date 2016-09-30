#! /bin/bash

if [ $(grep proxy ../share/auth.yml) ]; then
  export https_proxy=http://tprx.jtoa:80
  export http_proxy=http://tprx.jtoa:80
fi

bundle exec spring stop
cd ../
DATE=$(date +'%Y%m%d')
mv trade trade.$DATE
git clone https://github.com/toshiakisuda/trade.git
cd trade
bundle install --path vendor/bundler
rake db:migrate
rake db:seed

#! /bin/bash

if [ -n $https_proxy]; then
  export https_proxy=http://tprx.jtoa:80
  export http_proxy=http://tprx.jtoa:80
fi

cd ../
DATE=$(date +'%Y%m%d')
mv trade trade.$DATE
git clone https://github.com/toshiakisuda/trade.git
cd trade
bundle install --path vendor/bundler
rake db:migrate
rake db:seed

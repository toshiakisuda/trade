# coding: utf-8
require 'httpclient'
require 'date'

class GetFinanceData

  # 株価データダウンロードサイトからCSV形式で取得
  def get_finace(date)
    DOWNLOAD_DIR = "tmp/"
    DOWNLOAD_URL = "http://k-db.com/stocks/"
    begin
      hc = HTTPClient.new
      f = File.open(DOWNLOAD_DIR + date.to_s + ".csv","wb")
      content_sjis = hc.get_content(DOWNLOAD_URL + date.to_s + "/?download=csv")
      line_num = 1
      content = content_sjis.encode("UTF-8","Shift_JIS")
      f.print(content)
      f.close
      Rails.logger.info date.to_s + "の株価データを取得しました。"
     rescue => e
      Rails.logger.error date.to_s + "の株価データ取得に失敗しました" + e.message
    end
  end

  def get_nikkei_futures
    DOWNLOAD_DIR = "tmp/"
    DOWNLOAD_URL = "http://k-db.com/futures/F101-0000/5m/"
    begin
      hc = HTTPClient.new
      f = File.open(DOWNLOAD_DIR + date.to_s + "-nikkei_futures.csv","wb")
      content_sjis = hc.get_content(DOWNLOAD_URL + date.to_s + "/?download=csv")
      line_num = 1
      content = content_sjis.encode("UTF-8","Shift_JIS")
      f.print(content)
      f.close
      Rails.logger.info date.to_s + "の株価データを取得しました。"
    rescue => e
      Rails.logger.error date.to_s + "の株価データ取得に失敗しました" + e.message
    end
  end

  #当日の株価データを取得する
  def get_today
    date = Date.today
    self.get(date)
  end

  def get_period(start_date,end_date)
    dstart_date = Date.strptime(start_date,"%Y-%m-%d")
    dend_date = Date.strptime(end_date,"%Y-%m-%d")

    while dstart_date <= dend_date do
      self.get(dstart_date)
      dstart_date = dstart_date + 1

      sleep 30
    end
  end
end

require 'rails_helper'
require 'holiday.rb'

describe '土日祝日判定' do
  context '2016-09-09 10:00:00' do
    it "trueとなること" do
      (10..11).each{ |hour|
        time = Time.new(2016,9,9,hour)
        expect(time.trade_session?).to eq true
      }
    end
  end

  context '2016-01-01の時' do
    it "falseなること" do
      time = Time.new(2016,1,1)
      expect(time.trade_session?).to eq false 
    end
  end

  context '2016-08-11（山の日）の時' do
    it "falseとなること" do
      time = Time.new(2016,8,11)
      expect(time.trade_session?).to eq false
    end
  end

  context '土曜日の時' do
    it "falseとなること" do
      time = Time.new(2016,9,3)
      expect(time.trade_session?).to eq false
    end
  end

end

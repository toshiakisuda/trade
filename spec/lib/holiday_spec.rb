require 'rails_helper'
require 'holiday.rb'

describe '土日祝日判定' do
  context '2016-01-01の時' do
    it "trueとなること" do
      date = Date.new(2016,1,1)
      expect(date.holiday?).to eq true
    end
  end

  context '2016-08-11（山の日）の時' do
    it "trueとなること" do
      date = Date.new(2016,8,11)
      expect(date.holiday?).to eq true
    end
  end

  context '土曜日の時' do
    it "trueとなること" do
      date = Date.new(2016,9,3)
      expect(date.holiday?).to eq true
    end
  end

  context '平日の時' do
    it "falseとなること" do
      date = Date.new(2016,9,2)
      expect(date.holiday?).to eq false
    end
  end
end

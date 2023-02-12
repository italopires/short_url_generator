require 'rails_helper'

RSpec.describe UrlPresenter do
  let(:url) { create(:url) }
  subject(:presenter) { described_class.new(url.short_url) }

  describe '#initialize' do
    it 'finds the URL by short URL' do
      expect(Url).to receive(:find_by).with(short_url: url.short_url).and_return(url)
      presenter
    end
  end

  describe '#clicks' do
    let(:clicks) { [create(:click, url: url)] }

    it 'returns clicks for the URL' do
      expect(presenter.clicks).to eq(clicks)
    end
  end

  describe '#url' do
    it 'returns the URL' do
      expect(presenter.url).to eq(url)
    end
  end

  describe '#daily_clicks' do
    it "returns the daily clicks for the past 10 days" do
      days = [
        (Date.current - 9.days).strftime("%d").to_i,
        (Date.current - 8.days).strftime("%d").to_i,
        (Date.current - 7.days).strftime("%d").to_i,
        (Date.current - 6.days).strftime("%d").to_i,
        (Date.current - 5.days).strftime("%d").to_i,
        (Date.current - 4.days).strftime("%d").to_i,
        (Date.current - 3.days).strftime("%d").to_i,
        (Date.current - 2.days).strftime("%d").to_i,
        (Date.current - 1.days).strftime("%d").to_i,
        (Date.current).strftime("%d").to_i
      ]

      days.each_with_index do |day, index|
        create(:click, created_at: Date.current - (9 - index).days, url: url)
      end
      result = presenter.daily_clicks

      expect(result).to eq([
        [days[0].to_s, 1],
        [days[1].to_s, 1],
        [days[2].to_s, 1],
        [days[3].to_s, 1],
        [days[4].to_s, 1],
        [days[5].to_s, 1],
        [days[6].to_s, 1],
        [days[7].to_s, 1],
        [days[8].to_s, 1],
        [days[9].to_s, 1]
      ])
    end

    it "returns zero clicks for days with no clicks" do
      result = presenter.daily_clicks

      expect(result).to eq([
        [(Date.current - 9.days).strftime("%-d").to_s, 0],
        [(Date.current - 8.days).strftime("%-d").to_s, 0],
        [(Date.current - 7.days).strftime("%-d").to_s, 0],
        [(Date.current - 6.days).strftime("%-d").to_s, 0],
        [(Date.current - 5.days).strftime("%-d").to_s, 0],
        [(Date.current - 4.days).strftime("%-d").to_s, 0],
        [(Date.current - 3.days).strftime("%-d").to_s, 0],
        [(Date.current - 2.days).strftime("%-d").to_s, 0],
        [(Date.current - 1.days).strftime("%-d").to_s, 0],
        [(Date.current).strftime("%-d").to_s, 0]
      ])
    end
  end

  describe "#browsers_clicks" do
    it "returns the number of clicks by browser" do
      create_list(:click, 2, url: url, browser: "Chrome")
      create_list(:click, 3, url: url, browser: "Firefox")

      expect(presenter.browsers_clicks).to eq([["Chrome", 2], ["Firefox", 3]])
    end
  end

  describe "#platform_clicks" do
    it "returns the number of clicks by platform" do
      create_list(:click, 4, url: url, platform: "Windows")
      create_list(:click, 1, url: url, platform: "macOS")

      expect(presenter.platform_clicks).to eq([["Windows", 4], ["macOS", 1]])
    end
  end
end
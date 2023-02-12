# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  let(:url) { create :url }

  describe 'index' do
    it 'shows a list of short urls' do
      urls = create_list(:url, 10)
      
      visit root_path
      expect(page).to have_text('HeyURL!')
      # expect page to show 10 urls
      urls.each do |url|
        expect(page).to have_text(url.short_url)
      end
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      url = create(:url, original_url: 'http://www.google.com')
      # expect page to show the short url

      visit url_path(url.short_url)
      expect(page).to have_text(url.short_url)
      expect(page).to have_text(url.original_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('ABCDE')
        expect(page).to have_text('Not Found')
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        visit '/'
        fill_in 'url[original_url]', with: 'https://www.google.com'
        click_on 'Shorten URL'
        # Check that a new url has been created
        expect(page).to have_text 'Short URL was created successfuly'
        urls = Url.all
        expect(urls.size).to eq 1
        expect(page).to have_text urls.first.short_url
        expect(page).to have_text urls.first.original_url
      end

      it 'redirects to the home page' do
        visit '/'
        fill_in 'url[original_url]', with: 'https://www.google.com'
        click_on 'Shorten URL'
        expect(current_path).to eq(root_path)
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'
        fill_in 'url[original_url]', with: 'www.google.com'
        click_on 'Shorten URL'
        urls = Url.all
        expect(urls.size).to be_zero
        expect(page).to have_text 'Invalid URL. Please enter a valid URL'
      end

      it 'redirects to the home page' do
        visit '/'
        fill_in 'url[original_url]', with: 'www.google.com'
        click_on 'Shorten URL'
        urls = Url.all
        expect(urls.size).to be_zero
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      url = create(:url, original_url: 'https://www.google.com')

      visit visit_path(url.short_url)
      expect(current_url).to include(url.original_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        expect(page).to have_text('Not Found')
      end
    end
  end
end

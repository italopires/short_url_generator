# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'relationships' do
    it { is_expected.to have_many(:clicks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :original_url }
    it { is_expected.to validate_presence_of :short_url }

    context 'when original URL is a valid URL' do
      subject { build :url }

      it 'does not return invalid field message' do
        subject.valid?
        expect(subject.errors[:original_url]).to be_blank
      end
    end

    context 'when original URL is an invalid URL' do
      subject { build :url, original_url: 'www.google.com' }

      it 'returns invalid message' do
        subject.valid?
        expect(subject.errors[:original_url]).not_to be_blank
      end
    end
  end

  describe 'scopes' do
    describe '.latest_10' do
      let!(:url) { create(:url, created_at: Date.current - 20.days) }

      before { create_list(:url, 10) }

      it 'returns 10 records' do
        expect(Url.latest_10.count).to eq(10)
      end

      it 'returns only the latest 10 records' do
        expect(Url.latest_10).not_to include(url)
      end
    end
  end
end

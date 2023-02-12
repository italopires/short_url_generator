# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:url) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :browser }
    it { is_expected.to validate_presence_of :platform }
  end
end

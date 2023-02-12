require 'rails_helper'

RSpec.describe ShortCodeGenerator do
  describe '.generate' do
    it 'generates a unique short code' do
      allow(Url).to receive(:exists?).and_return(false)
      expect(described_class.generate).to be_a(String)
    end

    it 'generates a different code if the code already exists' do
      allow(Url).to receive(:exists?).and_return(true, false)
      code_1 = described_class.generate
      code_2 = described_class.generate
      expect(code_1).not_to eq(code_2)
    end
  end
end
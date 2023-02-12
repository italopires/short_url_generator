# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    short_url { ShortCodeGenerator.generate }
    sequence(:original_url) { |i| "https://domain#{i}.com/path" }
  end
end

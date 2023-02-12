# frozen_string_literal: true

FactoryBot.define do
  factory :click do
    url
    browser { FFaker::Internet.domain_name}
    platform { FFaker::AWS.product_description }
  end
end

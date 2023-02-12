# frozen_string_literal: true
require 'uri'

class Url < ApplicationRecord
  has_many :clicks

  validates :short_url, :original_url, presence: true
  validate :valid_url

  scope :latest_10, -> { order(created_at: :desc).limit(10) }
  
  # before_validation :generate_code

  private

  # def generate_code
  #   code = nil
  #   loop do
  #     code = ([*('A'..'Z')]).sample(5).join
  #     break unless Url.exists?(short_url: code)
  #   end

  #   self.short_url = code
  # end

  def valid_url
    valid = false
    begin
      uri = URI.parse(original_url)
      valid = uri.kind_of?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      valid = false
    end

    errors.add(:original_url, 'Invalid URL. Please enter a valid URL') unless valid
  end
end

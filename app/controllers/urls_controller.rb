# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.latest_10.includes(:clicks)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def generate_code
    code = nil
    loop do
      code = ([*('A'..'Z')]).sample(5).join
      break unless Url.exists?(short_url: code)
    end

    code
  end

  def create
    @url = Url.new url_params
    @url.short_url = ShortCodeGenerator.generate

    if @url.save
      redirect_to root_path, notice: 'Short URL was created successfuly'
    else
      redirect_to root_path, notice: @url.errors[:original_url].first
    end
  end

  def show
    @url_presenter = UrlPresenter.new(params[:url])

    render plain: "Not Found", status: :not_found if @url_presenter.url.nil?
  end

  def visit
    url = Url.where(short_url: params[:short_url]).pluck(:id, :original_url).first

    if url.nil?
      render plain: "Not Found", status: :not_found
    else
      Click.create(platform: browser.platform.name, browser: browser.name, url_id: url[0])
      redirect_to url[1]
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end

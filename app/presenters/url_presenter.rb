class UrlPresenter
  def initialize(url)
    @url = Url.find_by(short_url: url)
  end

  def clicks
    @clicks ||= @url.clicks.where("created_at > ?", Date.current - 10.days)
  end

  def url
    @url
  end

  def daily_clicks
    return @daily_clicks if @daily_clicks.present?

    @daily_clicks = clicks.group_by { |click| click.created_at.day }
      .map { |day, clicks| [day, clicks.size] }
      .map { |day, count| [day.to_s, count] }
      
    days = (0..9).map do |i|
      (Date.current - i.days).strftime("%d").to_i
    end.reverse
    
    days.each do |day|
      @daily_clicks << [day.to_s, 0] unless @daily_clicks.any? { |d, _| d == day.to_s }
    end
    
    @daily_clicks.sort_by! { |day, _| day.to_i }
  end

  def browsers_clicks
    @browsers_clicks ||= clicks_by(:browser)
  end

  def platform_clicks
    @platform_clicks ||= clicks_by(:platform)
  end

  private

  def clicks_by(key)
    clicks.group_by(&key).map { |name, clicks| [name.to_s, clicks.size] }
  end
end
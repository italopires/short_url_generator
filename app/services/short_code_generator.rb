class ShortCodeGenerator
  def self.generate
    code = nil
    loop do
      code = ([*('A'..'Z')]).sample(5).join
      break unless Url.exists?(short_url: code)
    end

    code
  end
end
class Bitly
  
  def self.get_short_url(obj, url, config)
    url = URI.parse("http://api.bit.ly/v3/shorten?login=#{config[:bitly_username]}&apiKey=#{config[:bitly_api_key]}&longUrl=#{URI.encode(url)}&format=json")
    res = Net::HTTP.get url
    res = ActiveSupport::JSON.decode(res)
    if res["status_code"] == 200
      return res["data"]["url"]
    else
      obj.errors.add('short_url', res["status_txt"])
      return false
    end
  end
end
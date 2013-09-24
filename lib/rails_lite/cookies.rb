require 'json'

class Session
  COOKIE_NAME = "_rails_lite_app"

  attr_reader :cookie

  def initialize(req)
    req.cookies.each do |cookie|
      puts "about to parse cookie: #{cookie}"
      if cookie.name == COOKIE_NAME
        @cookie = JSON::parse(cookie.value)
        # @cookie = { COOKIE_NAME => cookie.value }
        puts "parsed cookie: #{@cookie}"
      end
    end

    @cookie ||= {}
    # @cookie = { "_rails_lite_test_cookie" => "value" }
    puts "@cookie in Session#initialize: #{@cookie}"
  end

  def [](key)
    @cookie[key.to_s]
  end

  def []=(key, value)
    @cookie[key.to_s] = value
  end

  def store_session(response)
    puts "cookie about to be used for json generation: #{@cookie}"
    puts "JSON::generate(@cookie): #{JSON::generate(@cookie)}"
    # @cookie = WEBrick::Cookie.new(COOKIE_NAME, JSON::generate(@cookie))
    # @cookie = WEBrick::Cookie.new(COOKIE_NAME, "test")
    # response.cookies << @cookie
    response.cookies << WEBrick::Cookie.new(COOKIE_NAME, JSON::generate(@cookie))
    puts "response.cookies: #{response.cookies}"
  end
end
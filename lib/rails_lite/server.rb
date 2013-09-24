require 'webrick'
require_relative 'controller_base'


server = WEBrick::HTTPServer.new(:Port => 8080)
trap('INT') { server.shutdown }

# How to allow class definition to be under the instantiation of MyController?
class MyController < ControllerBase
  def go
    # session[:test_key] = "test_value 5"
    # session[:count] = 0

    # What is the proper way to get rid of a key?
    # session.delete(:test_key)

    session[:count] ||= 0
    session[:count] += 1

    case @req.path
    when "/redirect"
      redirect_to("http://www.google.com")
    when "/render"
      # content_type = "text/text"
      # body = "Hello, world! You requested #{@req.path} with content:\n" +
      #        "#{@req.query["content"]}"
      # render_content(body, content_type)
      render :show
      # @session.store_session(@res)
      puts "@res.cookies in MyController#go (when '/render'): #{@res.cookies}"
      puts "@session in MyController#go (when '/render'): #{@session.inspect}"
      puts "@session.cookie in MyController#go (when '/render'): #{@session.cookie}"
    end
  end
end

server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end

server.start

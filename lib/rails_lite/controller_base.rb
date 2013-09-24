require_relative 'cookies'
require 'active_support/core_ext'
require 'erb'

class ControllerBase
  def initialize(req, res)
    @req = req
    @res = res
    @session = Session.new(@req)
  end

  def render_content(body, content_type)
    @res.content_type = content_type
    @res.body = body
    @response_built = true
    @session.store_session(@res)
    puts "render_content's @res.cookies: #{@res.cookies}"
  end

  def render(action_name)
    file_name = "views/#{self.class.to_s.underscore}/#{action_name}.html.erb"
    template = ERB.new(File.read(file_name))

    render_content(template.result(binding), "text/html")
  end

  def redirect_to(url)
    @res.status = 302
    @res["Location"] = url
    @response_built = true
    @session.store_session(@res)
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(action_name)
    self.send(action_name)

    render(action_name) unless @response_built
  end
end

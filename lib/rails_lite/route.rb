class Route
  def initialize(url, http_method, controller_class, action_name)
    @url = url
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    req.request_method.downcase.to_sym == @http_method && req.path =~ @url
  end

  def run(req, res)
    controller = @controller_class.new(req, res)
    controller.invoke_action(action_name)
  end
end
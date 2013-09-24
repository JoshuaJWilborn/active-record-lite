class Router

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(Route.new(pattern, http_method, controller_class, action_name))
    end
  end

  def initialize
    @routes = []
  end

  def add_route(route)
    @routes << route
  end

  # def get(pattern, controller_class, action_name)
  #   @routes << Route.new(pattern, :get, controller_class, action_name)
  # end
  #
  # def post(pattern, controller_class, action_name)
  #   @routes << Route.new(pattern, :post, controller_class, action_name)
  # end

  def match(url)
    @routes.each do |route|
      return route if route.matches?(url)
    end

    nil
  end

  def run(req, res)
    matched_route = match(req.path)
    if matched_route
      matched_route.run(req, res)
    else
      res.status = 404
    end
  end

  def draw(&proc)
    # Test this:
    # Why can't you use proc.call? Won't that run the code in the block,
    # and have self already equal to router??
    self.instance_eval(&proc)
  end
end
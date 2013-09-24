require 'active_record_lite'

class MyMassObject < MassObject
  set_attrs :x, :y, :z
end

obj = MyMassObject.new(:x => :x_val, :y => :y_val, :z => "hi there")
p obj

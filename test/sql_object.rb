require 'active_record_lite'

# https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
cats_db_file_name =
  File.expand_path(File.join(File.dirname(__FILE__), "cats.db"))
DBConnection.open(cats_db_file_name)

class Cat < SQLObject
  set_table_name("cats")
  set_attrs(:id, :name, :owner_id)
end

class Human < SQLObject
  set_table_name("humans")
  set_attrs(:id, :fname, :lname, :house_id)
end

# p Human.find(1)
# p Cat.find(1)
# p Cat.find(2)
#
# p Cat.all
# p Human.all

# p DBConnection.execute("insert into cats (name, owner_id) values (?, ?)", "moocat", 2)
# p Cat.all

a = Cat.new(name: "bloop", owner_id: 2)
# puts "attributes: #{a.class.attributes}"
# puts "id: #{a.id}"
# puts "name: #{a.name}"
# puts "owner_id: #{a.owner_id}"
# puts "send(:id): #{a.send(:id)}"
# p a.attributes.map { |attr_name| puts "self: #{self}"; puts "attr_name #{attr_name}"; self.send(attr_name) }
# a.send()

c1 = Cat.new(id: 5, name:"test cat 1 more updates!!", owner_id: 2)
c2 = Cat.new(id: 6, name:"test cat 2 more updates!!", owner_id: 2)
# c3 = Cat.new(id: 19, name:"cat 3 updated again!", owner_id: 1)
c3 = Cat.new(name:"test cat 6", owner_id: 2)

p c1.attribute_values
p c2.attribute_values
p c3.attribute_values

p Cat.all
p "testing..."

c1.save
c2.save
c3.save

p c1
p c2
p c3
p Cat.all


#
# c = Cat.new(:name => "Gizmo", :owner_id => 1)
# c.save
#
# h = Human.find(1)
# # just run an UPDATE; no values changed, so shouldnt hurt the db
# h.save

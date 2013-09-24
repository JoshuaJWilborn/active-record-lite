require 'active_support/inflector'
require_relative 'has_many_assoc_params'
require_relative 'belongs_to_assoc_params'

module Associatable
  def belongs_to(name, params = {})
    assoc_params[name] = BelongsToAssocParams.new(self, name, params)

    define_method(name) do
      aps = BelongsToAssocParams.new(self, name, params)

      query = <<-SQL
        SELECT *
          FROM #{aps.other_table}
         WHERE #{aps.other_table}.#{aps.primary_key} = ?
      SQL

      row_hash = DBConnection.execute(query, self.send(aps.primary_key))

      aps.other_class.parse_all(row_hash).first
    end
  end

  def has_many(name, params = {})
    aps = HasManyAssocParams.new(self, name, params)

    define_method(name) do
      query = <<-SQL
        SELECT *
          FROM #{aps.other_table}
         WHERE #{aps.other_table}.#{aps.foreign_key} = ?
      SQL

      row_hashes = DBConnection.execute(query, self.send(aps.primary_key))

      aps.other_class.parse_all(row_hashes)
    end
  end

  def assoc_params
    @assoc_params ||= {}
    # Try commenting this out and see if things still work. It looks like I
    # should only need the first line? Or would that return a boolean?
    @assoc_params
  end

  def has_one_through(has_one_name, through_name, through_belongs_name, params = {})
    # has_one_through :house, :human, :house

    puts "assoc_params: #{assoc_params.inspect}"

    tps = assoc_params[through_name]
    puts "tps: #{tps.inspect}"

    puts "params: #{params}"
    # puts "through_belongs_params: #{tbps}"
    puts "through_belongs"

    # tbps = tps.other_class.assoc_params

    define_method(has_one_name) do

      query = <<-SQL
        SELECT *
          FROM #{tps.other_table}
          JOIN #{}
      SQL

      puts "query #{query}"

      row_hash = DBConnection.execute(query)

      # other_class.parse_all(row_hash) # change other_class to get from appropriate params hash
    end
  end
end
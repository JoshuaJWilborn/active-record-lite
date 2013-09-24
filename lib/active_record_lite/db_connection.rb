require 'sqlite3'

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true
  end

  def self.execute(*args)
    @db.execute(*args)
  end

  def self.last_insert_row_id
    @db.last_insert_row_id
  end

  private
  # Is this initialize method here so that it can explicitly be made private?
  # And if so, why does it bother having a parameter?
  def initialize(db_file_name)
  end
end

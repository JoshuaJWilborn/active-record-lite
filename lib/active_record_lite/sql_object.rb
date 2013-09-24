class SQLObject < MassObject
  extend Searchable
  extend Associatable

  def self.set_table_name(name)
    @table_name = name
  end

  def self.table_name
    @table_name
  end

  # Why did the assignment say to put this in MassObject?
  def self.parse_all(row_hashes)
    row_hashes.map { |row_hash| self.new(row_hash) }
  end

  def self.all
    row_hashes = DBConnection.execute("select * from #{self.table_name}")
    # This will not work (SQL does not use '?' for table names):
    # row_hashes = DBConnection.execute(<<-SQL, "cats")
    #   SELECT *
    #     FROM ?
    # SQL

    self.parse_all(row_hashes)
  end

  def self.find(id)
    row_hashes = DBConnection.execute(<<-SQL, id)
      SELECT *
        FROM #{self.table_name}
       WHERE id = ?
    SQL

    self.parse_all(row_hashes).first
  end

  def attribute_values
    self.class.attributes.map { |attr_name| self.send(attr_name) }
  end

  def save
    id.nil? ? create : update
  end

  private

  def create
    my_attrs = self.class.attributes
    my_values = attribute_values
    DBConnection.execute(<<-SQL, *my_values)
      INSERT INTO #{ self.class.table_name } (#{ my_attrs.join(', ') })
           VALUES (#{ (['?'] * my_values.count).join(', ') })
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    my_attrs = self.class.attributes
    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE #{ self.class.table_name }
      SET #{ (my_attrs.map { |attr_name| "#{ attr_name } = ?"}).join(', ') }
      WHERE id = ?
    SQL
  end
end
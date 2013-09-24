module Searchable
  def where(params)
    DBConnection.execute(<<-SQL, *params.values)
      SELECT *
        FROM #{ self.table_name }
       WHERE #{ params.keys.map { |key| "#{key} = ?"}.join(' AND ')}
    SQL
  end
end
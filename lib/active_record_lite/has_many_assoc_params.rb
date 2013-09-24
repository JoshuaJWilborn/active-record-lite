class HasManyAssocParams
  def initialize(self_class, name, params)
    @self_class = self_class
    @name = name
    @params = params
  end

  def other_class
    (if @params[:class_name]
      @params[:class_name]
    else
      "#{@name}".singularize.camelize
    end).constantize
  end

  def other_table
    other_class.table_name
  end

  def primary_key
    @params[:primary_key] ? @params[:primary_key] : "id"
  end

  def foreign_key
    if @params[:foreign_key]
      @params[:foreign_key]
    else
      "#{@self_class.to_s.underscore}_id"
    end
  end
end
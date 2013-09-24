class MassObject
  @attributes = []

  def self.attributes
    @attributes
  end

  # Implement my own attr_accessor?
  def self.set_attrs(*attributes)
    # Why iterate instead of this?
    # @attributes = attributes
    # self.send(:attr_accessor, *attributes)
    @attributes = []
    attributes.each do |attribute|
      self.send(:attr_accessor, attribute)
      @attributes << attribute
    end

    nil
  end

  # Why did the assignment say to put this in MassObject?
  # def self.parse_all(row_hashes)
  #   row_hashes.map { |row_hash| self.new(row_hash) }
  # end

  def initialize(params)
    params.each do |attr_name, value|
      unless self.class.attributes.include?(attr_name.to_sym)
        raise "mass assignment to unregistered attribute #{attr_name}"
      end

      self.send("#{attr_name}=", value)
    end
  end
end

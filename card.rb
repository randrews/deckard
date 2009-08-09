class Deckard::Card
  attr_accessor :items
  attr_accessor :properties

  def initialize properties
    self.properties = properties
    self.items = []
  end

  def [] sub
    (sub.is_a?(Numeric) ? items : properties)[sub]
  end

  def << item
    items << item
  end
end

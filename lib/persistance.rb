class Persistance
  @@hash = {}

  def self.persist(key, val)
    @@hash[key] = val
  end

  def self.fetch(key)
    @@hash[key]
  end
end

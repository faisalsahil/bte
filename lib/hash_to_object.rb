module HashToObject

  def self.convert(hash)
    json   = hash.to_json
    object = JSON.parse(json, object_class: OpenStruct)
  end

end
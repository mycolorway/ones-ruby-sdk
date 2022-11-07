class Object
  def to_ones_query(key)
    "#{key.to_ones_param}=#{to_ones_param.to_s}"
  end

  def to_ones_param
    to_s
  end
end

class NilClass
  def to_ones_param
    'null'
  end
end

class TrueClass
  # Returns +self+.
  def to_ones_param
    self
  end
end

class FalseClass
  # Returns +self+.
  def to_ones_param
    self
  end
end

class Array
  def to_ones_query(key)
    if empty?
      nil.to_ones_query(prefix)
    else
      collect.with_index { |value, index| value.to_ones_query("#{key}[#{index}]") }.join "&"
    end
  end

  def to_ones_param
    collect(&:to_ones_param).join "/"
  end
end

class Hash
  def to_ones_query(namespace = nil)
    query = collect do |key, value|
      value = "" if (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
      value.to_ones_query(namespace ? "#{namespace}[#{key}]" : key)
    end.compact

    query.sort! unless namespace.to_s.include?("[]")
    query.join("&")
  end

  alias_method :to_ones_param, :to_ones_query
end

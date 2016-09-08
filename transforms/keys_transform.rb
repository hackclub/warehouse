class KeysTransform
  MAPPING = {
    camel_case: {
      symbol: 'to_fmted_sym'
    }
  }

  def initialize(source, desired)
    if MAPPING[source][desired]
      @transform_method_name = MAPPING[source][desired]
    else
      raise ArgumentError, 'Unknown source type provided'
    end
  end

  def process(row)
    transform_hash_keys(row)
  end

  private

  def transform_hash_keys(val)
    case val
    when Array
      val.map { |v| transform_hash_keys(v) }
    when Hash
      res = val.map do |k, v|
        [
          self.send(@transform_method_name, k.to_s),
          transform_hash_keys(v)
        ]
      end

      Hash[res]
    else
      val
    end
  end

  def to_fmted_sym(str)
    to_snake_case(str).to_sym
  end

  def to_snake_case(str)
    str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      gsub(/ +/,'_').
      tr("-", "_").
      downcase
  end
end

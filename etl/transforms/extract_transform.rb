class ExtractTransform
  # You can optionally pass a Hash instead of an Array to have selection
  # extractions on the _type field.
  def initialize(to_extract)
    case to_extract
    when Hash
      @is_hash = true
    when Array
      @is_hash = false
    end

    @to_extract = to_extract
  end

  def process(row)
    if @is_hash
      columns_to_extract = [:_type].concat @to_extract[row[:_type]]
    else
      columns_to_extract = @to_extract
    end

    row.select { |k, v| columns_to_extract.include? k }
  end
end

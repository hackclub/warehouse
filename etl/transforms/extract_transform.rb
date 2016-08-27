class ExtractTransform
  def initialize(to_extract)
    @to_extract = to_extract
  end

  def process(row)
    row.select { |k, v| @to_extract.include? k }
  end
end

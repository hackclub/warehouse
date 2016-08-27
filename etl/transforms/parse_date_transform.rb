require 'date'

class ParseDateTransform
  def initialize(to_parse)
    @to_parse = to_parse
  end

  def process(row)
    @to_parse.each do |k|
      milliseconds_since_epoch = row[k]

      row[k] = Time.at(milliseconds_since_epoch / 1000).to_datetime
    end

    row
  end
end

require 'date'

class ParseDateTransform
  def initialize(should_transform_lambda)
    @should_transform_lam = should_transform_lambda
  end

  def process(row)
    row.each do |k, v|
      if @should_transform_lam.call(row, k, v)
        milliseconds_since_epoch = row[k]

        row[k] = Time.at(milliseconds_since_epoch / 1000).to_datetime
      end
    end

    row
  end
end

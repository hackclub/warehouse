class InsertPairsTransform
  def initialize(insert_rules, should_check_type)
    @should_check_type = should_check_type
    @insert_rules = insert_rules
  end

  def process(row)
    if @should_check_type
      pairs_to_insert = @insert_rules[row[:_type]]
    else
      pairs_to_insert = @insert_rules
    end

    pairs_to_insert.each { |k, v| row[k] = v  }

    row
  end
end

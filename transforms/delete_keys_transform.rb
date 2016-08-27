class DeleteKeysTransform
  def initialize(keys_to_delete)
    @keys_to_delete = keys_to_delete
  end

  def process(row)
    @keys_to_delete.each do |k|
      row.delete k
    end

    row
  end
end

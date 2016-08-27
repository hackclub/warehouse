require_relative '../lib/common.rb'

class WarehouseDestination
  def initialize(database_url, table, primary_key)
    @db = Sequel.connect(database_url)
    @table = @db[table]
    @pk = primary_key
  end

  def write(row)
    # This hash tells Sequel what to update on conflict
    update_hash = row.clone

    # This'll make it look like: { b: => :excluded__b }
    #
    # This tells Sequel to update all of the attributes in the table to their
    # equivalent attribute in values for the attempted insert.
    update_hash.each { | k, v | update_hash[k] = "excluded__#{k}".to_sym }

    # But we don't want to update the primary key!
    update_hash.delete(@pk)

    @table.insert_conflict(target: @pk, update: update_hash).insert(row)
  end

  def close
    @db.disconnect
  end
end

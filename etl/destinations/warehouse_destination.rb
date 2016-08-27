require_relative '../lib/common.rb'

# WarehouseDestination saves incoming data to Hack Club's primary data
# warehouse.
#
# database_url - the URL to the Postgres instance
# table - the table to write passed in rows to, this can be overridden, see the
#         docs for the write method
# primary_key - the unique, unchangeable identifier for rows, this can also be
#               overriden, see docs for the write method
class WarehouseDestination
  def initialize(database_url, table=nil, primary_key=nil)
    @db = Sequel.connect(database_url)
    @table = @db[table]
    @pk = primary_key
  end

  # Write takes in individual rows consisting of key value pairs and writes them
  # to the database in the table specified in initialize. They're uniquely
  # identified by the primary_key field passed in by initialize.
  #
  # table and primary_key can optionally be overridden on a row-by-row basis by
  # setting the :_table and :_primary_key fields on a row, respectively.
  def write(row)
    table = @table
    pk = @pk

    if row[:_table] and row[:_primary_key]
      table = @db[row[:_table]]
      pk = row[:_primary_key]
    end

    # Strip all metadata before proceeding
    row.delete(:_table)
    row.delete(:_primary_key)

    # This hash tells Sequel what to update on conflict
    update_hash = row.clone

    # This'll make it look like: { b: => :excluded__b }
    #
    # This tells Sequel to update all of the attributes in the table to their
    # equivalent attribute in values for the attempted insert.
    update_hash.each { | k, v | update_hash[k] = "excluded__#{k}".to_sym }

    # We don't want to update the primary key!
    update_hash.delete(pk)

    table.insert_conflict(target: pk, update: update_hash).insert(row)
  end

  def close
    @db.disconnect
  end
end

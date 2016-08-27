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
    @table = table
    @pk = primary_key
  end

  # Write takes in individual rows consisting of key value pairs and writes them
  # to the database in the table specified in initialize. They're uniquely
  # identified by the primary_key field passed in by initialize.
  #
  # table and primary_key can optionally be overridden on a row-by-row basis by
  # setting the :_table and :_primary_key fields on a row, respectively.
  #
  # If :_primary_key doesn't exist, write will use the constraint called
  # {table_name}_pkey to uniquely identify rows.
  def write(row)
    pk = row[:_primary_key] || @pk
    table = row[:_table] || @table

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

    if pk
      # We don't want to update the primary key!
      update_hash.delete(pk)

      @db[table].insert_conflict(target: pk, update: update_hash).insert(row)
    else
      pk_constraint = guess_private_key_constraint_name(table)

      @db[table].insert_conflict(
        constraint: pk_constraint,
        update: update_hash
      ).insert(row)
    end
  end

  def close
    @db.disconnect
  end

  private

  def guess_private_key_constraint_name(table)
    without_schema = table.to_s.gsub(/^.*__/, '')
    guessed_pk_name = without_schema + '_pkey'

    guessed_pk_name.to_sym
  end
end

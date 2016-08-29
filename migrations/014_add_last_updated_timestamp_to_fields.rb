Sequel.migration do
  change do
    alter_table :streak__fields do
      add_column :last_updated_timestamp, 'timestamp', null: false
    end
  end
end

Sequel.migration do
  up do
    create_schema :streak

    create_table :streak__users do
      column :key, 'text', primary_key: true
      column :creation_timestamp, 'timestamp', null: false
      column :last_updated_timestamp, 'timestamp', null: false
      column :email, 'text', unique: true, null: false
      column :display_name, 'text'
      column :is_oauth_complete, 'boolean', null: false
      column :last_seen_timestamp, 'timestamp', null: false
    end
  end

  down do
    drop_table :streak__users
    drop_schema :streak
  end
end

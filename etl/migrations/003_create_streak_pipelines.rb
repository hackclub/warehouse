Sequel.migration do
  change do
    create_table :streak__pipelines do
      column :key, 'text', primary_key: true
      column :creation_timestamp, 'timestamp', null: false
      column :last_updated_timestamp, 'timestamp', null: false
      column :creator_key, 'text', null: false
      column :name, 'text', null: false
      column :description, 'text'
      column :org_wide, 'boolean', null: false
    end
  end
end

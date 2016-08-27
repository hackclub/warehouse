Sequel.migration do
  change do
    create_table :streak__boxes do
      column :key, 'text', primary_key: true
      column :creation_timestamp, 'timestamp', null: false
      column :last_updated_timestamp, 'timestamp', null: false
      foreign_key :creator_key, :streak__users, type: 'text', null: false
      foreign_key :pipeline_key, :streak__pipelines, type: 'text', null: false
      column :name, 'text', null: false
      column :notes, 'text'
    end
  end
end

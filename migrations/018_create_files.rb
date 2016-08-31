Sequel.migration do
  up do
    create_enum :file_type, %w(GMAIL_API DRIVE)

    create_table :streak__files do
      column :key, 'text', primary_key: true

      column :creation_timestamp, 'timestamp', null: false
      column :last_updated_timestamp, 'timestamp', null: false
      column :last_saved_timestamp, 'timestamp', null: false

      foreign_key :box_key, :streak__boxes, type: 'text', null: false
      foreign_key :owner_key, :streak__users, type: 'text', null: false

      column :type, :file_type, null: false

      column :file_name, 'text', null: false
      column :main_file_name, 'text', null: false

      column :size, 'integer'
      column :mime_type, 'text', null: false

      column :gmail_api_file_id, 'text'
      column :gmail_message_id, 'text'

      column :drive_url, 'text'
      column :drive_file_id, 'text'
      column :drive_owner_id, 'text'
    end

    run %(
ALTER TABLE streak.files
  ADD CONSTRAINT file_type_required_fields
    CHECK (
      (type = 'GMAIL_API'
        AND gmail_api_file_id IS NOT NULL
        AND gmail_message_id IS NOT NULL
        AND size IS NOT NULL)
      OR
      (type = 'DRIVE'
        AND drive_url IS NOT NULL
        AND drive_file_id IS NOT NULL
        AND drive_owner_id IS NOT NULL)
    )
)
  end

  down do
    drop_table :streak__files
    drop_enum :file_type
  end
end

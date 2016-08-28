Sequel.migration do
  up do
    create_enum :field_type, %w(DATE DROPDOWN FORMULA PERSON TEXT_INPUT)

    create_table(:streak__fields) do
      column :key, 'text', null: false
      foreign_key :pipeline_key, :streak__pipelines, type: 'text', null: false
      column :name, 'text', null: false
      column :type, :field_type, null: false
    end

    run %(
ALTER TABLE streak.fields
  ADD CONSTRAINT fields_pkey PRIMARY KEY (key, pipeline_key)
)
  end

  down do
    drop_table :streak__fields
    drop_enum :field_type
  end
end

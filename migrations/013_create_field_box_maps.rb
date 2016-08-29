Sequel.migration do
  up do
    create_table(:streak__field_box_maps) do
      column :field_key, 'text', null: false
      foreign_key :pipeline_key, :streak__pipelines, type: 'text', null: false
      foreign_key :box_key, :streak__boxes, type: 'text', null: false
      column :value, 'json'
    end

    run %(
ALTER TABLE streak.field_box_maps
  ADD CONSTRAINT field_box_maps_field_fkey FOREIGN KEY (field_key, pipeline_key)
    REFERENCES streak.fields (key, pipeline_key)
    MATCH FULL
)

    run %(
ALTER TABLE streak.field_box_maps
  ADD CONSTRAINT field_box_maps_pkey PRIMARY KEY (field_key, pipeline_key, box_key)
)
  end

  down do
    drop_table(:streak__field_box_maps)
  end
end

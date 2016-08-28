Sequel.migration do
  up do
    # Create streak.stages table
    create_table(:streak__stages) do
      column :key, 'text', null: false
      foreign_key :pipeline_key, :streak__pipelines, type: 'text', null: false
      column :name, 'text', null: false
    end

    run %(
ALTER TABLE streak.stages
  ADD CONSTRAINT stages_pkey PRIMARY KEY (key, pipeline_key)
)

    # Add stage_key column to streak.boxes with appropriate foreign key
    alter_table(:streak__boxes) do
      add_column :stage_key, 'text', null: false
    end

    run %(
ALTER TABLE streak.boxes
  ADD CONSTRAINT boxes_stage_fkey
    FOREIGN KEY (stage_key, pipeline_key)
      REFERENCES streak.stages (key, pipeline_key)
      MATCH FULL
)
  end

  down do
    alter_table(:streak__boxes) do
      drop_constraint :boxes_stage_fkey
      drop_column :stage_key
    end

    drop_table :streak__stages
  end
end

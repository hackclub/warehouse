Sequel.migration do
  change do
    create_table :sheets__slack_stats do
      column :date, 'date', primary_key: true
      column :messages_from_people, 'integer', null: false
      column :messages_from_integrations, 'integer', null: false
      column :files_uploaded, 'integer', null: false
      column :people_posting, 'integer', null: false
      column :people_reading, 'integer', null: false
      column :team_size, 'integer', null: false
    end
  end
end

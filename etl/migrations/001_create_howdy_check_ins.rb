Sequel.migration do
  up do
    create_schema :sheets

    create_table :sheets__howdy_check_ins do
      primary_key :id
      column :date, 'date', null: false
      column :club_leader_key, 'text', unique: true, null: false
      column :week_attendance, 'integer', null: false
      column :confidence_in_club_future, 'integer', null: false
      column :club_progress_blockers, 'text', null: false
      column :how_can_hack_club_help, 'text', null: false
    end
  end

  down do
    drop_table :sheets__howdy_check_ins
    drop_schema :sheets
  end
end

Sequel.migration do
  change do
    create_enum :task_status, %w(DONE NOT_DONE)
    create_enum :reminder_status, %w(NONE SCHEDULED REMINDED ERROR_ON_REMINDER NOT_REMINDED_BECAUSE_TASK_DONE)

    create_table :streak__tasks do
      primary_key :key, 'text'
      column :creation_date, 'timestamp', null: false
      column :last_status_change_date, 'timestamp', null: false
      foreign_key :box_key, :streak__boxes, type: 'text', null: false
      foreign_key :creator_key, :streak__users, type: 'text', null: false
      column :due_date, 'timestamp'
      column :text, 'text', null: false
      column :status, :task_status, null: false
      column :reminder_status, :reminder_status, null: false
    end
  end
end

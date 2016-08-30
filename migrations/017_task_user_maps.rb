Sequel.migration do
  change do
    create_join_table(
      {
        task_key: {
          table: :streak__tasks,
          type: 'text'
        },
        user_key: {
          table: :streak__users,
          type: 'text'
        }
      },
      name: :streak__task_user_maps
    )
  end
end
